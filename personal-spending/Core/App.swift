//
//  App.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 25/05/2023.
//

import Foundation
import SwiftDate

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]


final class App {
    
    static let name = "カロママ"
    static let code = "CM"
    static let region: Region = Region(tz: TimeZoneName.asiaTokyo, cal: CalendarName.gregorian, loc: LocaleName.japanese)
    static let regionEng: Region = Region(tz: TimeZoneName.asiaTokyo, cal: .gregorian, loc: LocaleName.english)
}

extension UIColor {
    public class func RGB(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1) -> UIColor {
        let red = max(0.0, min(CGFloat(red) / 255.0, 1.0))
        let green = max(0.0, min(CGFloat(green) / 255.0, 1.0))
        let blue = max(0.0, min(CGFloat(blue) / 255.0, 1.0))
        let alpha = max(0.0, min(alpha, 1.0))
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UITableView {
    func reloadData(_ completion: @escaping () -> Void) {

        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { (_) in
                completion()
            })
    }
}
