//
//  WelcomeViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 06/06/2023.
//

import UIKit
import CoreData
import SwiftUtils
import MessageUI

protocol MailDelegate: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
}

class WelcomeViewController: UIViewController, MailDelegate {
    @IBOutlet weak var goldImage1: UIImageView!
    @IBOutlet weak var goldImage2: UIImageView!
    @IBOutlet weak var goldImage3: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    let date = App.region.today().toString(.date)
    var users: [NSManagedObject] = []
    var goldClearLogo = 0
    var isShowingCalendar = false

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = ExtenStrings.descriptions.first
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(closeLifeLogCalendar),
            name: NSNotification.Name(rawValue: kCloseLifeLogCalendar),
            object: nil)
        getDateUser()
        setupUILogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUserDefaultShowStamp()
    }

    @IBAction func tapFacebook(_ sender: Any) {
        let standard = UserDefaults.standard
        goldClearLogo = standard.integer(forKey: ExtenStrings.kClearLogo)
        if standard.string(forKey: ExtenStrings.kDateToDay) == date {
            addDateUser(dateString: App.region.today().toString(.date))
            standard.set(date, forKey: ExtenStrings.kDateToDay)
            let stamp = standard.integer(forKey: ExtenStrings.kStampToDate)
            standard.set(stamp + 1, forKey: ExtenStrings.kStampToDate)
            showStampPopup(nil, stamp: stamp + 1, dailyStamp: 1, animation: true) {
                if stamp + 1 == 4 {
                    standard.set(0, forKey: ExtenStrings.kStampToDate)
                    standard.set(self.goldClearLogo + 1, forKey: ExtenStrings.kClearLogo)
                    self.goldClearLogo = self.goldClearLogo + 1
                    self.setupUILogo()
                    let vc = PopupCongratsActionViewController()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
            }
        }
    }

    @IBAction func calendarTouchUp(_ sender: Any) {
        if !isShowingCalendar {
            showLifeLogCalendar2()
            isShowingCalendar = true
        }
    }
    
    @IBAction func tapEmail(_ sender: Any) {
        print("-----\(users)")
        let user = users[0]
        let dateString = (user.value(forKey: "date") as? String) ?? ""
        print("----date: \(dateString)")
        openMail()
    }
    
    func openFaceBook() {
        guard let url = URL(string: "https://www.facebook.com/truonghaily.2111") else { return }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func openMail() {
        if let vc = ContactLinkMailManager.createControllerEmail(delegate: self) {
            present(vc, animated: true, completion: nil)
        }
    }
    
    func setupUILogo() {
        if goldClearLogo == 1 {
            goldImage1.image = UIImage(named: "icon_gold_medal")
        } else if goldClearLogo == 2 {
            goldImage1.image = UIImage(named: "icon_gold_medal")
            goldImage2.image = UIImage(named: "icon_gold_medal")
        } else if goldClearLogo == 3 {
            goldImage1.image = UIImage(named: "icon_gold_medal")
            goldImage2.image = UIImage(named: "icon_gold_medal")
            goldImage3.image = UIImage(named: "icon_gold_medal")
        }
    }
    
    func getDateUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DateUser")
        do {
          users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func addDateUser(dateString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DateUser", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(dateString, forKey: "date")
        do {
            try managedContext.save()
            users.append(user)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func setUserDefaultShowStamp() {
        let standard = UserDefaults.standard
        goldClearLogo = standard.integer(forKey: ExtenStrings.kClearLogo)
        if standard.string(forKey: ExtenStrings.kDateToDay) != date {
            addDateUser(dateString: App.region.today().toString(.date))
            standard.set(date, forKey: ExtenStrings.kDateToDay)
            let stamp = standard.integer(forKey: ExtenStrings.kStampToDate)
            standard.set(stamp + 1, forKey: ExtenStrings.kStampToDate)
            showStampPopup(nil, stamp: stamp + 1, dailyStamp: 1, animation: true) {
                if stamp + 1 == 20 {
                    standard.set(0, forKey: ExtenStrings.kStampToDate)
                    standard.set(self.goldClearLogo + 1, forKey: ExtenStrings.kClearLogo)
                    self.goldClearLogo = self.goldClearLogo + 1
                    self.setupUILogo()
                    let vc = PopupCongratsActionViewController()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
            }
        }
    }

    fileprivate func showStampPopup(_ thumImage: UIImage?, stamp: Int, dailyStamp: Int, animation: Bool, complete: @escaping () -> Void) {
        let vc = DisplayStampViewController()
        vc.totalStamp = stamp
        vc.isAnimation = animation
        vc.thumImage = thumImage
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.setCloseClosure({
            complete()
        })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.present(vc, animated: animation, completion: nil)
//        }
    }

    @objc private func closeLifeLogCalendar(_ sender: Any?) {
        if let child = children.first, let vc = child as? LifeLogCalendarPageViewController {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            isShowingCalendar = false
        }
    }
    
    private func showLifeLogCalendar2() {

        let vc = LifeLogCalendarPageViewController.vc()
        vc.viewModel = LifeLogCalendarPageViewModel(currentDate: App.region.today(), dateUsers: users)
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

extension WelcomeViewController: PopupCongratsActionViewControllerDelegate {
    func controller(_ controller: PopupCongratsActionViewController, needPerform action: PopupCongratsActionViewController.Action) {
        if goldClearLogo == 3 {
            UserDefaults.standard.set(0, forKey: ExtenStrings.kClearLogo)
            let vc = PopupEnoughClearViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true)
        }
    }
}

extension WelcomeViewController {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class ContactLinkMailManager {
    
    // MARK: - Send Email / Message
    class func createControllerEmail(delegate: MailDelegate) -> UIViewController? {
        var address = "haily.211194@gmail.com"
        
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = delegate
            vc.setToRecipients([address])
            vc.modalPresentationStyle = .fullScreen
            return vc
        } else if MFMessageComposeViewController.canSendText() {
            let vc = MFMessageComposeViewController()
            vc.messageComposeDelegate = delegate
            vc.recipients = [address]
            vc.modalPresentationStyle = .fullScreen
            return vc
        } else {
            let alert = AlertController(title: "", message: "Your phone currently does not have a mail app.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.present()
            return nil
        }
    }
}
