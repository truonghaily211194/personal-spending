//
//  HomeViewModel.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 25/05/2023.
//

import Foundation

final class LifeLogHistory {

    private(set) var date: Date = Date()
    private(set) var lifeLogHistoryDate: LifeLogHistoryDate!

    init(date: Date, lifeLogHistoryDate: LifeLogHistoryDate) {
        self.date = date
        self.lifeLogHistoryDate = lifeLogHistoryDate
    }
}

final class LifeLogHistoryDate {

    private(set) var activity: String = ""
    private(set) var health: String = ""
    private(set) var breastfeeding: String = ""
    private(set) var sleep: String = ""
    private(set) var water: String = ""
    private(set) var memo: String = ""
    private(set) var medicine: String = ""
    private(set) var calorieConsumption: Int = 0
    private(set) var calorieIntake: Int = 0
    private(set) var totalScore: Int = 0

    init(activity: String, health: String, breastfeeding: String, sleep: String, water: String, memo: String, medicine: String, calorieConsumption: Int, calorieIntake: Int, totalScore: Int) {
        self.activity = activity
        self.health = health
        self.breastfeeding = breastfeeding
        self.sleep = sleep
        self.water = water
        self.memo = memo
        self.medicine = medicine
        self.calorieConsumption = calorieConsumption
        self.calorieIntake = calorieIntake
        self.totalScore = totalScore
    }
}

class HomeViewModel {

    private var lifeLogHistoryMonth: [[LifeLogHistory]] = [[LifeLogHistory(date: App.region.today().absoluteDate, lifeLogHistoryDate: LifeLogHistoryDate(activity: "activity 1", health: "health 1", breastfeeding: "breastfeeding 1", sleep: "sleep 1", water: "water 1", memo: "memo 1", medicine: "medicine 1", calorieConsumption: 1, calorieIntake: 1, totalScore: 1)),
        LifeLogHistory(date: App.region.today().absoluteDate, lifeLogHistoryDate: LifeLogHistoryDate(activity: "activity 2", health: "health 2", breastfeeding: "breastfeeding 2", sleep: "sleep 2", water: "water 2", memo: "memo 2", medicine: "medicine 2", calorieConsumption: 2, calorieIntake: 2, totalScore: 2))

        ]]
    private(set) var today = App.region.today()

    func getCellForRowAt(atIndexPath indexPath: IndexPath) -> LifeLogHistoryTableViewCellViewModel? {
        guard indexPath.row < lifeLogHistoryMonth[indexPath.section].count else { return nil }
        let lifeLogHistory = lifeLogHistoryMonth[indexPath.section][indexPath.row]
        return LifeLogHistoryTableViewCellViewModel(date: lifeLogHistory.date.inRegion(region: App.region), lifeLogHistoryDate: lifeLogHistory.lifeLogHistoryDate)
    }

    func numberOfRowsInsection(inSection section: Int) -> Int {
        return lifeLogHistoryMonth[section].count
    }

    func numberOfSection() -> Int {
        return lifeLogHistoryMonth.count
    }

    func titleForHeader(inSection section: Int) -> HistoryHeaderViewModel? {
        guard let dateInRegion = lifeLogHistoryMonth[section].first?.date.inRegion(region: App.region) else { return nil }
        let year = dateInRegion.year
        let month = dateInRegion.month
        return HistoryHeaderViewModel(title: "\(month) / \(year)")
    }
    
    func updateLifeLogHistoriesMonth(items: [[LifeLogHistory]]) {
        // Update today to loadmore next time
        guard let date = items.last?.last?.date.inRegion() else { return }
        today = date.add(components: 11.days) ?? date
        lifeLogHistoryMonth = items
    }
}
