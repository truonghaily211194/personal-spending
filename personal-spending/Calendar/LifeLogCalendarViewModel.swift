//
//  LifeLogCalendarViewModel.swift
//  CM
//
//  Created by MBP0039 on 5/17/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import SwiftDate
import SwiftUtils
import CoreData

final class LifeLogCalendarViewModel {

    enum Action {
        case updateCalendar(height: CGFloat)
    }

    enum DateStatus {
        case indate(type: DateType)
        case outdate
    }

    enum DateType {
        case future
        case current
        case pass
    }

    enum MealStatus {
        case notInput
        case input(kcalLevel: ScoreLevel)
    }

    enum ScoreLevel {
        case zero
        case from1To49
        case from50To79
        case from80To100
        case greater100

        var range: CountableClosedRange<Int> {
            switch self {
            case .zero:    return 0...0
            case .from1To49: return 1...49
            case .from50To79: return 50...79
            case .from80To100: return 80...100
            case .greater100: return 101...Int.max
            }
          }

          init(_ score: Int) {
            switch score {
            case ScoreLevel.zero.range:
                self = .zero
            case ScoreLevel.from1To49.range:
                self = .from1To49
            case ScoreLevel.from50To79.range:
                self = .from50To79
            case ScoreLevel.from80To100.range:
                self = .from80To100
            case ScoreLevel.greater100.range:
                self = .greater100
            default:
                self = .zero
            }
          }

        var color: UIColor? {
            switch self {
            case .zero:
                return Color.Calendar.firstBorderLevelScore
            case .from1To49:
                return Color.Calendar.secondBorderLevelScore
            case .from50To79:
                return Color.Calendar.thirdBorderLevelScore
            case .from80To100:
                return Color.Calendar.fourthBorderLevelScore
            case .greater100:
                return Color.Calendar.fourthBorderLevelScore
            }
        }
    }

    struct DateItem {
        var date: DateInRegion?
        var dateStatus: DateStatus
        var mealStatus: MealStatus?
    }

    // MARK: - Properties
    let today = App.region.today()
    var currentDate = App.region.today().startOf(component: .month)
    var currentMonth = App.region.today().startOf(component: .month)
    var dateItems: [DateItem] = []
    var lifeLogHistories: [LifeLogHistory] = []
//    var healthScores: [HealthScore] = []

    var dateSelect = App.region.today()
    var indexDateSelect = 0
    var isDateSelect = false
    var dateUsers: [NSManagedObject] = []

    init(currentDate: DateInRegion, dateUsers: [NSManagedObject]) {
        self.currentDate = currentDate
        self.dateUsers = dateUsers
    }

    fileprivate func handleShowDateSelect() {
        isDateSelect = false
        for i in 0..<numberOfItem() {
            if let date = dateAtIndexPath(IndexPath(item: i, section: 0)) {
                if date == dateSelect {
                    indexDateSelect = IndexPath(item: i, section: 0).row
                    isDateSelect = true
                }
            }
        }
    }

    func setupData() {
        dateItems = []
        for i in 0..<numberOfItem() {
            if let date = dateAtIndexPath(IndexPath(item: i, section: 0)) {
                let begin = currentDate.startOf(component: .month)
                let end = currentDate.endOf(component: .month)

                let today = App.region.today()
                var dateType: DateType = .future
                if date.startOfDay == today {
                    dateType = .current
                } else if date.startOfDay > today {
                    dateType = .future
                } else {
                    dateType = .pass
                }

                var dateStatus: DateStatus = .outdate
                if date >= begin && date <= end {
                    dateStatus = .indate(type: dateType)
                } else {
                    dateStatus = .outdate
                }
                dateItems.append(DateItem(date: date, dateStatus: dateStatus, mealStatus: nil))
            }
        }
    }

    func reloadMealStatus() {
        for i in 0..<dateItems.count {
            if let date = dateAtIndexPath(IndexPath(item: i, section: 0)) {
                let mealStatus = getMealStatus(date: date.absoluteDate)
                dateItems[i].mealStatus = mealStatus
            }
        }
    }

    private func getMealStatus(date: Date) -> MealStatus? {
//        guard let healthScore = healthScores.filter({ $0.date == date }).first else { return nil }
//        let isInputApp = healthScore.isInputApp
//        if isInputApp {
//            let totalScore = healthScore.score
//            let scoreLevel = ScoreLevel(totalScore)
//            return .input(kcalLevel: scoreLevel)
//        } else {
//            return .notInput
//        }
        return .notInput
    }

    func dateAtIndexPath(_ indexPath: IndexPath) -> DateInRegion? {
        let begin = currentDate.startOf(component: .month)
        let left = begin.weekday - 2 >= 0 ? begin.weekday - 2 : 7 - begin.weekday
        guard let newDate = begin.add(components: (indexPath.item - left).day) else {
            return nil
        }
        return newDate
    }

    fileprivate func numberOfItem() -> Int {
        let begin = currentDate.startOf(component: .month)
        let end = currentDate.endOf(component: .month)
        let left = begin.weekday - 2 >= 0 ? begin.weekday - 2 : 7 - begin.weekday
        let right = 7 - (end.weekday - 1) == 7 ? 0 : 7 - (end.weekday - 1)
        return currentDate.monthDays + left + right
    }

    func heightCalendar() -> CGFloat {
        let heightForItem = LifeLogCalendarViewController.Config.widthForItem
        let numberOfRows: CGFloat = numberOfItem() % 7 == 0 ? CGFloat((numberOfItem() / 7)) : CGFloat((numberOfItem() / 7) + 1)
        let spaceOfRows: CGFloat = (numberOfRows - 1) * LifeLogCalendarViewController.Config.spaceForItem
        return numberOfRows * heightForItem + spaceOfRows  + 105
    }

    func isCurrentTime() -> Bool {
        let currentMonth = App.region.today().month
        let currentYear = App.region.today().year
        return currentDate.month == currentMonth && currentDate.year == currentYear
    }
    
    func isDidGetStamps(indexPath: IndexPath) -> Bool {
        let user = dateUsers[0]
        let dateString = (user.value(forKey: "date") as? String) ?? ""
        print("----date: \(dateString)")
        let dateItemString = dateItems[indexPath.row].date?.toString(.date)
        for index in 0..<dateUsers.count {
            let dateString = dateUsers[index].value(forKey: "date") as? String ?? ""
            if dateString == dateItemString {
                return true
            }
        }
        return false
    }
}

// MARK: - Service
extension LifeLogCalendarViewModel {

//    func getLifeLogHistories(completion: @escaping ApiCompletion) {
//        lifeLogHistories.removeAll()
//        let fromDate = currentDate.startOf(component: .month)
//        let toDate = !isCurrentTime() ? currentDate.endOf(component: .month) : currentDate
//        let param = LifeLogHistoryServices.QueryParams(fromDate: fromDate, toDate: toDate)
//        LifeLogHistoryServices.getHistory(params: param) { [weak self] (items, error) in
//            // For enable title calendar button after api finish
//            let object: [String: Any?] = ["items": items]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kFinishGetLifelogHistory), object: object)
//
//            guard let this = self else {
//                completion(.failure(CMError.instanceRelease))
//                return
//            }
//            if let error = error {
//                completion(.failure(error))
//            } else if let items = items as? [LifeLogHistory] {
//                this.lifeLogHistories = items
//                completion(.success)
//            }
//        }
//    }

//    func getHealthScores(completion: @escaping ApiCompletion) {
//        healthScores.removeAll()
//        let fromDate = currentDate.startOf(component: .month)
//        let toDate = !isCurrentTime() ? currentDate.endOf(component: .month) : currentDate
//        let param = LifeLogHistoryServices.QueryParams(fromDate: fromDate, toDate: toDate)
//        LifeLogHistoryServices.getHealthScores(params: param) { [weak self] (items, error) in
//            guard let this = self else {
//                completion(.failure(CMError.instanceRelease))
//                return
//            }
//            if let error = error {
//                completion(.failure(error))
//            } else if let items = items as? [HealthScore] {
//                this.healthScores = items
//                completion(.success)
//            }
//        }
//    }
}
