//
//  SwiftDate.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 25/05/2023.
//

import SwiftDate
import SwiftUtils

enum CMDateFormat {
    /// yyyy-MM-dd
    case date
    /// yyyy/M/d
    case dateShort
    /// yyyy/MM/dd
    case dateShort2
    /// yyyy-MM-dd hh:mm:ss
    case dateTime
    /// M/d
    case monthDay
    /// EEE
    case weekday
    /// hh:mm:ss
    case time
    /// hh:mm
    case hourMinute
    /// h:mm
    case shortHourMinute
    /// yyyy/MM/dd H:mm
    case dateTimeNotSeconds
    /// yyyy.M.d H:mm
    case shortTime
    /// h:mm:a
    case dateTime2
    case dateTime3
    case dateTimeNotAvailableCoupon
    /// yyyy/MM/dd HH:mm
    case dateTime4
    case japaneDate
    case japaneDateLong
    case japaneDateShort
    case japaneDateShort2
    /// yyyyMMdd
    case dateCustomForPost
    case dateTime5
    /// yyyy/MM/dd
    case japanDateShort3
    case japaneDateFullSizeCharacter
    case englishDate
    case englishDate2
    case englishDateShort2

    var dateFormat: DateFormat {
        switch self {
        case .date:
            return .custom("yyyy-MM-dd")
        case .dateShort:
            return .custom("yyyy/M/d")
        case .dateShort2:
            return .custom("yyyy/MM/dd")
        case .dateTime:
            return .custom("yyyy-MM-dd HH:mm:ss")
        case .monthDay:
            return .custom("M/d")
        case .weekday:
            return .custom("EEE")
        case .time:
            return .custom("HH:mm:ss")
        case .hourMinute:
            return .custom("HH:mm")
        case .shortHourMinute:
            return .custom("H:mm")
        case .dateTimeNotSeconds:
            return .custom("yyyy/MM/dd HH:mm")
        case .dateTime2:
            return .custom("yyyy.M.d H:mm")
        case .dateTime3:
            return .custom("yyyy.M.d")
        case .dateTime4:
            return .custom("yyyy/MM/dd HH:mm")
        case .japaneDate:
            return .custom("M月d日(E)")
        case .japaneDateLong:
            return .custom("yyyy年MM月dd日")
        case .japaneDateShort:
            return .custom("yyyy年M月d日")
        case .dateTimeNotAvailableCoupon:
            return .custom("yyyy年M月d日 HH:mm")
        case .japaneDateShort2:
            return .custom("yyyy年M月d日（E）")
        case .englishDateShort2:
            return .custom("dd/MM/yyyy（E）")
        case .japanDateShort3:
            return .custom("yyyy/MM/dd（E）")
        case .dateCustomForPost:
            return .custom("yyyyMMdd")
        case .dateTime5:
            return .custom("yyyy-MM-dd'T'HH:mm:ss.SSS")
        case .japaneDateFullSizeCharacter:
            return .custom("M月d日（E）")
        case .shortTime:
            return .custom("h:mm:a")
        case .englishDate:
            return .custom("MM/dd (E)")
        case .englishDate2:
            return .custom("dd/MM/yyyy")
        }
    }
}

// MARK: - DateInRegion
extension DateInRegion {
    func toString(_ format: CMDateFormat) -> String {
        return string(format: format.dateFormat)
    }

    var localAbsoluteDate: Date {
        let seconds = self.region.timeZone.secondsFromGMT(for: self.absoluteDate)
        return Date(timeInterval: TimeInterval(seconds), since: self.absoluteDate)
    }
}

// MARK: - String to Date
extension String {
    func toDate(format: CMDateFormat, region: Region) -> DateInRegion? {
        return DateInRegion(string: self, format: format.dateFormat, fromRegion: region)
    }
}

// MARK: - UIDatePicker
extension UIDatePicker {
    func setRegion(region: Region) {
        calendar = region.calendar
        timeZone = region.timeZone
        locale = region.locale
    }
}

// MARK: - NSDateFormatter
extension DateFormatter {
    func setRegion(region: Region) {
        calendar = region.calendar
        timeZone = region.timeZone
        locale = region.locale
    }
}

// MARK: - NSDateComponents
extension DateComponents {
    init(time: String) {
        var comps = time.components(separatedBy: ":")
        if comps.count != 3 {
            comps = ["0", "0", "0"]
        }
        self.init()
        hour = comps[0].intValue
        minute = comps[1].intValue
        second = comps[2].intValue
    }
}

// MARK: - Region
extension Region {
    func today() -> DateInRegion {
        return DateInRegion(absoluteDate: Date(), in: self).startOfDay
    }

    func now() -> DateInRegion {
        return DateInRegion(absoluteDate: Date(), in: self)
    }

    func tomorrow() -> DateInRegion {
        let today = App.region.today()
        let tomorrow = today.add(components: 1.days)
        return tomorrow ?? today
    }
}

// MARK: - DateInRegion
extension DateInRegion {

    public convenience init? (
        era: Int = 0,
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        nanosecond: Int = 0,
        region: Region? = nil) {

        let newComponents: [Calendar.Component: Int] = [.year: year, .month: month, .hour: hour, .day: day, .minute: minute, .second: second, .nanosecond: nanosecond]
        self.init(components: newComponents, fromRegion: region)
    }

    public func difference(_ toDate: DateInRegion, unitFlags: Set<Calendar.Component>) -> DateComponents? {
        return region.calendar.dateComponents(unitFlags, from: self.absoluteDate, to: toDate.absoluteDate)
    }
}

