//
//  LifeLogHistoryTableViewCellViewModel.swift
//  CM
//
//  Created by NganHa on 1/11/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import Foundation
import SwiftDate

final class LifeLogHistoryTableViewCellViewModel {

    private(set) var date: DateInRegion
    private(set) var lifeLogHistoryDate: LifeLogHistoryDate?

    var healthViewIsHidden: Bool {
        return true
    }
    var activitiesViewIsHidden: Bool {
        return true
    }
    var feelingViewIsHidden: Bool {
        return true
    }
    var inputWaterViewIsHidden: Bool {
        return true
    }
    var sleepViewIsHidden: Bool {
        return true
    }
    var breastfeedingViewIsHidden: Bool {
        return true
    }
    var medicineViewIsHidden: Bool {
        return true
    }

    var memoLabelIsHidden: Bool {
        return true
    }

    var caloConsumpIsHidden: Bool {
        return true
    }

    var caloIntakeIsHidden: Bool {
        return true
    }

    var totalScoreIsHidden: Bool {
        return true
    }

    var isAllHidden: Bool {
        return true
    }
    
    init(date: DateInRegion, lifeLogHistoryDate: LifeLogHistoryDate?) {
        self.date = date
        self.lifeLogHistoryDate = lifeLogHistoryDate
    }

    func getFoodName() -> String {
        return "asasd"
    }

    func convertCalorieDecimal(_ calorie: Int) -> String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.groupingSeparator = ","
//        guard let calorieDecimal = numberFormatter.string(from: NSNumber(value: calorie)) else { return "" }
        return "calorieDecimal"
    }
}
