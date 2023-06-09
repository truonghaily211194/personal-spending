//
//  LifeLogCalendarViewController.swift
//  CM
//
//  Created by MBP0039 on 5/17/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import SwiftDate

let kLifeLogCalendar = "kLifeLogCalendar"
let kCloseLifeLogCalendar = "kCloseLifeLogCalendar"

protocol LifeLogCalendarViewControllerDelegate: class {

    func controller(_ controller: LifeLogCalendarViewController, needPerform action: LifeLogCalendarViewModel.Action)
}

final class LifeLogCalendarViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var weekdayContainerView: UIView!

    var viewModel: LifeLogCalendarViewModel?
    weak var delegate: LifeLogCalendarViewControllerDelegate?

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupData()
        getHealthScores()
        getLifeLogHistories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let viewModel = viewModel else { return }
        delegate?.controller(self, needPerform: .updateCalendar(height: viewModel.heightCalendar()))
    }

    private func setupCollectionView() {
        collectionView.register(LifeLogCalendarCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = Config.spaceForItem
        layout.minimumLineSpacing = Config.spaceForItem
        collectionView.collectionViewLayout = layout
    }

    private func setupData() {
        guard let viewModel = viewModel else { return }

        viewModel.setupData()
        collectionView.reloadData()
    }

    private func getLifeLogHistories() {
    }

    private func getHealthScores() {
    }
}

// MARK: Extension UICollectionViewDelegate, UICollectionViewDataSource
extension LifeLogCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.widthForItem, height: Config.widthForItem)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.dateItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(LifeLogCalendarCollectionCell.self, forIndexPath: indexPath)
        let dateItem = viewModel.dateItems[indexPath.row]
        let cellViewModel = LifeLogCalendarCollectionCellViewModel(dateItem: dateItem, didGetStamp: viewModel.isDidGetStamps(indexPath: indexPath))
        cell.viewModel = cellViewModel
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel, let dateSelect = viewModel.dateAtIndexPath(indexPath) else { return }
        let begin = viewModel.currentDate.startOf(component: .month)
        if dateSelect >= begin && dateSelect <= viewModel.today {
            let object: [String: Any] = ["date": dateSelect, "id": ""]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLifeLogCalendar), object: object)
        }
    }
}

// Extension: LifeLogCalendarViewController
extension LifeLogCalendarViewController {

    struct Config {
        static let spaceForItem: CGFloat = 15
        static let widthForItem: CGFloat = (kScreenSize.width - spaceForItem * 6 - 50) / 7
    }
}
