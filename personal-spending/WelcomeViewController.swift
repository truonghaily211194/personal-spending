//
//  WelcomeViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 06/06/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var goldImage1: UIImageView!
    @IBOutlet weak var goldImage2: UIImageView!
    @IBOutlet weak var goldImage3: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = ExtenStrings.descriptions.first

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.shadowColor = .clear
            appearance.backgroundColor = UIColor.RGB(246, 246, 246)
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor.RGB(246, 246, 246)
        }
        updateNavigationItem(isShowingCalendar: false)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(closeLifeLogCalendar),
            name: NSNotification.Name(rawValue: kCloseLifeLogCalendar),
            object: nil)
    }

    @IBAction func tapFacebook(_ sender: Any) {
        showStampPopup(nil, stamp: 21, dailyStamp: 1, animation: true) {
            print("aaaa")
        }
    }

    @IBAction func tapEmail(_ sender: Any) {
    }
    
    fileprivate func showStampPopup(_ thumImage: UIImage?, stamp: Int, dailyStamp: Int, animation: Bool, complete: @escaping () -> Void) {
        let vc = DisplayStampViewController()
        vc.totalStamp = stamp
        vc.isAnimation = animation
        vc.thumImage = thumImage
        vc.setCloseClosure({
            complete()
        })
        navigationController?.present(vc, animated: animation, completion: nil)
    }
    
    private func updateNavigationItem(isShowingCalendar: Bool) {
        if !isShowingCalendar {
            title = "Home"
            customCalendarButton()
            navigationItem.leftBarButtonItem = nil
        } else {
            title = "Calendar"
            closeLifeLogCalendar(nil)
            customCloseButton()
        }
    }
    
    private func customCloseButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeLifeLogCalendar(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "ic_close_calendar"), for: .normal)
        button.setImage(UIImage(named: "ic_close_calendar"), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.sizeToFit()
        let item = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = item
    }
    
    private func customBackButton() {
        let backButton = customBackItemBlue(atTarget: self, selector: #selector(back(_:)))
        backButton.accessibilityIdentifier = "btnBack"
        navigationItem.leftBarButtonItem = backButton
    }
    
    func customBackItemBlue(atTarget target: Any?, selector: Selector, stringBack: String =  "back") -> UIBarButtonItem {
        let button = UIButton()
        button.accessibilityIdentifier = "btnBack"
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.setTitle(stringBack, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setImage(UIImage(named: "icon_arrow_left_blue"), for: .normal)
        button.setImage(UIImage(named: "icon_arrow_left_blue"), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }
    
    @objc func back(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func closeLifeLogCalendar(_ sender: Any?) {
        updateNavigationItem(isShowingCalendar: false)

        if let child = children.first, let vc = child as? LifeLogCalendarPageViewController {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }

    private func customCalendarButton() {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        button.addTarget(self, action: #selector(showLifeLogCalendar(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "ic_lifelog_calendar"), for: .normal)
        button.setImage(UIImage(named: "ic_lifelog_calendar"), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.sizeToFit()
        let item = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func showLifeLogCalendar(_ sender: Any?) {
        updateNavigationItem(isShowingCalendar: true)

        let vc = LifeLogCalendarPageViewController.vc()
        vc.viewModel = LifeLogCalendarPageViewModel(currentDate: App.region.today())
        vc.view.frame = CGRect(x: self.view.bounds.origin.x, y: -self.view.bounds.size.height, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                vc.view.frame = self.view.bounds
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    vc.updateBackgroundView(alpha: 0.2)
                }, completion: nil)
            })
    }
    
}
