//
//  Color.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 25/05/2023.
//

import Foundation
import UIKit

final class Color {
    static let overlay = UIColor.RGB(0, 0, 0, 0.6)
    struct Calendar {
        static let firstBorderLevelScore = UIColor(named: "firstBorderLevelScore")
        static let secondBorderLevelScore = UIColor(named: "secondBorderLevelScore")
        static let thirdBorderLevelScore = UIColor(named: "thirdBorderLevelScore")
        static let fourthBorderLevelScore = UIColor(named: "fourthBorderLevelScore")
    }

    struct Text {
        static let mainText = UIColor(named: "mainText")
        static let subText = UIColor(named: "subText")
        static let boldTitle = UIColor(named: "boldText")
        static let placeholder = UIColor(named: "placeholderText")
        static let whiteText = UIColor(named: "whiteText")
    }
    
    struct Border {
        static let borderMemo = UIColor(named: "parts_border")
        static let innerBorder = UIColor(named: "innerBorder")
    }
}
