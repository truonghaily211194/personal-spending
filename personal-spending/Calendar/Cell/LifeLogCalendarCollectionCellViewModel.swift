//
//  LifeLogCalendarCollectionCellViewModel.swift
//  CM
//
//  Created by MBP0039 on 5/17/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import SwiftDate

final class LifeLogCalendarCollectionCellViewModel {

    var dateItem: LifeLogCalendarViewModel.DateItem?
    var didGetStamp: Bool

    init(dateItem: LifeLogCalendarViewModel.DateItem, didGetStamp: Bool) {
        self.dateItem = dateItem
        self.didGetStamp = didGetStamp
    }
}
