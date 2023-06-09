//
//  LifeLogCalendarPageViewController.swift
//  CM
//
//  Created by MBP0039 on 5/17/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftDate
import SwiftUtils

protocol LifeLogCalendarPageViewControllerDelegate: class {

    func controller(_ controller: LifeLogCalendarPageViewController, needPerform action: LifeLogCalendarPageViewModel.Action)
}

final class LifeLogCalendarPageViewController: ViewController {

    @IBOutlet private weak var calendarContainerView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var monthTitleButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var heightCalendarView: NSLayoutConstraint!

    // MARK: Properties
    var viewModel: LifeLogCalendarPageViewModel?
    weak var delegate: LifeLogCalendarPageViewControllerDelegate?

    private lazy var titleDateFormatter: DateFormatter = {
        let fmt = DateFormatter()
            fmt.setRegion(region: App.regionEng)
            fmt.setLocalizedDateFormatFromTemplate("yMMM")
        return fmt
    }()

    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configNotification()
        self.addChild(pageViewController)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        addTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpPageViewController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: - Private
    private func setupUI() {
        backgroundView.alpha = 0
        updateUI()
    }


    private func configNotification() {
    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
    }

    private func setUpPageViewController() {
        guard let viewModel = viewModel else { return }
        let vc = LifeLogCalendarViewController.vc()
        vc.viewModel = viewModel.viewModelForLifeLogCalendar(pageDirection: nil)
        vc.delegate = self
        pageViewController.setViewControllers([vc], direction: .reverse, animated: false, completion: nil)
        let contentView = pageViewController.view ?? UIView()
        calendarContainerView.addSubview(contentView)
//        contentView.autoPinEdgesToSuperviewEdges()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: calendarContainerView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor)
        ])
        view.layoutIfNeeded()
    }

    private func updateColorNextButton() {
        guard let viewModel = viewModel else { return }
        let isDisableNextButton = viewModel.isCurrentTime()
        let imageButton = UIImage(named: "ic_next_gray_calendar")?.withRenderingMode(.alwaysTemplate)
        nextButton.tintColor = isDisableNextButton ? Color.Border.innerBorder : Color.Text.mainText
        nextButton.setImage(imageButton, for: .normal)
        nextButton.isEnabled = !isDisableNextButton
    }

    private func updateUI() {
        updateColorNextButton()
        let title = titleDateFormatter.string(from: viewModel?.currentDate.absoluteDate ?? Date())
        monthTitleButton.setTitle(title, for: .normal)
        monthTitleButton.setTitle(title, for: .selected)
    }

    private func updateStatusTitleButton(api number: Int) {
        guard let viewModel = viewModel else { return }
        viewModel.numberOfApisLoading += number
        monthTitleButton.isEnabled = viewModel.isEnableTitleButton()
    }

    // MARK: - Publics
    func updateBackgroundView(alpha: CGFloat) {
        backgroundView.alpha = alpha
    }

    // MARK: - ObjecC
    @objc private func handleDismiss(_ sender: Any?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCloseLifeLogCalendar), object: nil)
    }

    @objc private func addLifelogHistories(_ notification: Foundation.Notification) {
        guard let info = notification.object as? JSObject, let items = info["items"] as? [LifeLogHistory] else { return }
        guard let viewModel = viewModel else { return }
        viewModel.addLifeLogHistories(items: items)
        updateStatusTitleButton(api: -1)
    }

    @objc private func updateNumberApiLoading (_ notification: Foundation.Notification) {
        updateStatusTitleButton(api: 1)
    }

    // MARK: - IBActions
    @IBAction private func titleButtonTouchUpInside() {
        guard let viewModel = viewModel else { return }
        let items = viewModel.getLifeLogHistoriesMonth()
        let section = viewModel.getSectionIndexToScroll()
        delegate?.controller(self, needPerform: .reloadLifeLogHistory(lifeLogHistoriesMonth: items, section: section))
    }

    @IBAction private func previousMonthButtonTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        let vc = LifeLogCalendarViewController.vc()
        vc.viewModel = viewModel.viewModelForLifeLogCalendar(pageDirection: .reverse)
        vc.delegate = self

        let newCurrentDate = viewModel.currentDate - 1.month
        viewModel.updateCurrentDate(newValue: newCurrentDate)
        view.isUserInteractionEnabled = false
        pageViewController.setViewControllers([vc], direction: .reverse, animated: true) { _ in
            self.view.isUserInteractionEnabled = true
            self.updateUI()
        }
    }

    @IBAction private func nextMonthButtonTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel, !viewModel.isCurrentTime() else { return }
        let vc = LifeLogCalendarViewController.vc()
        vc.viewModel = viewModel.viewModelForLifeLogCalendar(pageDirection: .forward)
        vc.delegate = self

        let newCurrentDate = viewModel.currentDate + 1.month
        viewModel.updateCurrentDate(newValue: newCurrentDate)
        view.isUserInteractionEnabled = false
        pageViewController.setViewControllers([vc], direction: .forward, animated: true) { _ in
            self.view.isUserInteractionEnabled = true
            self.updateUI()
        }
    }
}

// MARK: - PageViewController
extension LifeLogCalendarPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewModel = viewModel else { return nil }
        let vc = LifeLogCalendarViewController.vc()
        vc.viewModel = viewModel.viewModelForLifeLogCalendar(pageDirection: .reverse)
        vc.delegate = self
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewModel = viewModel, !viewModel.isCurrentTime() else { return nil }
        let vc = LifeLogCalendarViewController.vc()
        vc.viewModel = viewModel.viewModelForLifeLogCalendar(pageDirection: .forward)
        vc.delegate = self
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewModel = viewModel,
            let vc = pageViewController.viewControllers?.last as? LifeLogCalendarViewController else { return }
        viewModel.updateCurrentDate(newValue: vc.viewModel?.currentDate ?? App.region.today())
        view.isUserInteractionEnabled = true
        updateUI()
    }
}

// MARK: - Extension LifeLogCalendarViewControllerDelegate
extension LifeLogCalendarPageViewController: LifeLogCalendarViewControllerDelegate {

    func controller(_ controller: LifeLogCalendarViewController, needPerform action: LifeLogCalendarViewModel.Action) {
        switch action {
        case .updateCalendar(let height):
            DispatchQueue.main.async { [weak self] in
                guard let this = self else { return }
                this.heightCalendarView.constant = height
                this.view.layoutIfNeeded()
            }
        }
    }
}
