////
////  HomeViewController.swift
////  personal-spending
////
////  Created by Ly Truong H. VN.Danang on 25/05/2023.
////
//
//import UIKit
//
//class HomeViewController: UIViewController {
//    @IBOutlet weak var tableview: UITableView!
//    
//    let viewModel = HomeViewModel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configTableView()
//        title = "Name"
//        if #available(iOS 15.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithDefaultBackground()
//            appearance.shadowColor = .clear
//            appearance.backgroundColor = UIColor.RGB(246, 246, 246)
//            navigationController?.navigationBar.standardAppearance = appearance
//            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
//        } else {
//            navigationController?.navigationBar.barTintColor = UIColor.RGB(246, 246, 246)
//        }
//        updateNavigationItem(isShowingCalendar: false)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(closeLifeLogCalendar),
//            name: NSNotification.Name(rawValue: kCloseLifeLogCalendar),
//            object: nil)
//    }
//    
//    private func configTableView() {
//        tableview.dataSource = self
//        tableview.delegate = self
//        tableview.register(HistoryHeaderView.self)
//        tableview.register(LifeLogHistoryTableViewCell.self)
//        tableview.estimatedRowHeight = 100
//        tableview.rowHeight = UITableView.automaticDimension
//    }
//    
//    private func updateNavigationItem(isShowingCalendar: Bool) {
//        if !isShowingCalendar {
//            title = "Home"
//            customCalendarButton()
//            navigationItem.leftBarButtonItem = nil
//        } else {
//            title = "Calendar"
//            closeLifeLogCalendar(nil)
//            customCloseButton()
//        }
//    }
//    
//    private func customCloseButton() {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(closeLifeLogCalendar(_:)), for: .touchUpInside)
//        button.setImage(UIImage(named: "ic_close_calendar"), for: .normal)
//        button.setImage(UIImage(named: "ic_close_calendar"), for: .highlighted)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        button.sizeToFit()
//        let item = UIBarButtonItem(customView: button)
//        navigationItem.leftBarButtonItem = item
//    }
//    
//    private func customBackButton() {
//        let backButton = customBackItemBlue(atTarget: self, selector: #selector(back(_:)))
//        backButton.accessibilityIdentifier = "btnBack"
//        navigationItem.leftBarButtonItem = backButton
//    }
//    
//    func customBackItemBlue(atTarget target: Any?, selector: Selector, stringBack: String =  "back") -> UIBarButtonItem {
//        let button = UIButton()
//        button.accessibilityIdentifier = "btnBack"
//        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
//        button.addTarget(target, action: selector, for: .touchUpInside)
//        button.setTitle(stringBack, for: .normal)
//        button.setTitleColor(UIColor.blue, for: .normal)
//        button.setImage(UIImage(named: "icon_arrow_left_blue"), for: .normal)
//        button.setImage(UIImage(named: "icon_arrow_left_blue"), for: .highlighted)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
//        button.sizeToFit()
//        return UIBarButtonItem(customView: button)
//    }
//    
//    @objc func back(_ sender: Any?) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @objc private func closeLifeLogCalendar(_ sender: Any?) {
//        updateNavigationItem(isShowingCalendar: false)
//
//        if let child = children.first, let vc = child as? LifeLogCalendarPageViewController {
//            vc.willMove(toParent: nil)
//            vc.view.removeFromSuperview()
//            vc.removeFromParent()
//        }
//    }
//
//    private func customCalendarButton() {
//        let button = UIButton()
//        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
//        button.addTarget(self, action: #selector(showLifeLogCalendar(_:)), for: .touchUpInside)
//        button.setImage(UIImage(named: "ic_lifelog_calendar"), for: .normal)
//        button.setImage(UIImage(named: "ic_lifelog_calendar"), for: .highlighted)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        button.sizeToFit()
//        let item = UIBarButtonItem(customView: button)
//        navigationItem.rightBarButtonItem = item
//    }
//    
//    @objc private func showLifeLogCalendar(_ sender: Any?) {
//        updateNavigationItem(isShowingCalendar: true)
//
//        let vc = LifeLogCalendarPageViewController.vc()
//        vc.delegate = self
//        vc.viewModel = LifeLogCalendarPageViewModel(currentDate: App.region.today(), dateUsers: )
//        vc.view.frame = CGRect(x: self.view.bounds.origin.x, y: -self.view.bounds.size.height, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
//        addChild(vc)
//        view.addSubview(vc.view)
//        vc.didMove(toParent: self)
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            usingSpringWithDamping: 1,
//            initialSpringVelocity: 1,
//            options: .curveEaseOut,
//            animations: {
//                vc.view.frame = self.view.bounds
//                self.view.layoutIfNeeded()
//            },
//            completion: { _ in
//                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//                    vc.updateBackgroundView(alpha: 0.2)
//                }, completion: nil)
//            })
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension HomeViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension HomeViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.numberOfSection()
////        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfRowsInsection(inSection: section)
////        return 20
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(LifeLogHistoryTableViewCell.self)
//        cell.viewModel = viewModel.getCellForRowAt(atIndexPath: indexPath)
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeue(HistoryHeaderView.self)
//        view.viewModel = viewModel.titleForHeader(inSection: section)
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        if viewModel.checkLoadMore(indexPath: indexPath) {
////            loadMore()
////        }
//    }
//}
//
//extension HomeViewController: LifeLogCalendarPageViewControllerDelegate {
//
//    func controller(_ controller: LifeLogCalendarPageViewController, needPerform action: LifeLogCalendarPageViewModel.Action) {
//        switch action {
//        case .reloadLifeLogHistory(let items, let section):
//            closeLifeLogCalendar(nil)
//            viewModel.updateLifeLogHistoriesMonth(items: items)
//            tableview.reloadData {
//                let position = IndexPath(row: 0, section: section)
//                self.tableview.scrollToRow(at: position, at: .top, animated: false)
//            }
//        }
//    }
//}
