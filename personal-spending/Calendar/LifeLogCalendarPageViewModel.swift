//
//  LifeLogCalendarPageViewModel.swift
//  CM
//
//  Created by MBP0039 on 5/17/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import Foundation
import SwiftDate

final class LifeLogCalendarPageViewModel {

    enum Action {
        case reloadLifeLogHistory(lifeLogHistoriesMonth: [[LifeLogHistory]], section: Int)
    }

    private(set) var currentDate = App.region.today()
    private(set) var lifeLogHistoriesMonth: [[LifeLogHistory]] = []
    private(set) var dates: [DateInRegion] = [] // Array of the first day in month
    var numberOfApisLoading: Int = 0

    init(currentDate: DateInRegion) {
        self.currentDate = currentDate
    }

    func viewModelForLifeLogCalendar(pageDirection: UIPageViewController.NavigationDirection?) -> LifeLogCalendarViewModel {
        var date = currentDate
        if let pageDirection = pageDirection {
            date = pageDirection == .reverse ? currentDate - 1.month : currentDate + 1.month
        }
        let viewModel = LifeLogCalendarViewModel(currentDate: date)
        return viewModel
    }

    func isCurrentTime() -> Bool {
        let currentMonth = App.region.today().month
        let currentYear = App.region.today().year
        return currentDate.month == currentMonth && currentDate.year == currentYear
    }

    func updateCurrentDate(newValue currentDate: DateInRegion) {
        self.currentDate = currentDate
    }

    func addLifeLogHistories(items: [LifeLogHistory]) {
        guard let item = items.first else { return }
        let date = item.date.inRegion(region: App.region)
        if !dates.contains(date) {
            dates.append(date)
            lifeLogHistoriesMonth.append(items)
        }
    }

    func getLifeLogHistoriesMonth() -> [[LifeLogHistory]] {
        lifeLogHistoriesMonth.sort { pre, next -> Bool in
            guard let preItem = pre.first, let nextItem = next.first else { return false }
            let preDate = preItem.date.inRegion(region: App.region)
            let nextDate = nextItem.date.inRegion(region: App.region)
            return preDate > nextDate
        }
        return lifeLogHistoriesMonth
    }

    func getSectionIndexToScroll() -> Int {
        dates.sort { $0 > $1 }
        for i in 0..<dates.count where dates[i].month == currentDate.month && dates[i].year == currentDate.year {
            return i
        }
        return 0
    }

    func isEnableTitleButton() -> Bool {
        return numberOfApisLoading == 0
    }
}
