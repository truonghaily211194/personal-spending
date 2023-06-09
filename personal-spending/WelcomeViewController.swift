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
import GoogleMobileAds
import PhotosUI
// ca-app-pub-1480390762284051~6234422931
// ca-app-pub-1480390762284051/8402556741

protocol MailDelegate: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
}

class WelcomeViewController: UIViewController, MailDelegate, GADBannerViewDelegate {
    @IBOutlet weak var goldImage1: UIImageView!
    @IBOutlet weak var goldImage2: UIImageView!
    @IBOutlet weak var goldImage3: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!

    let date = App.region.today().toString(.date)
    var users: [NSManagedObject] = []
    var goldClearLogo = 0
    var isShowingCalendar = false
    let bannerView: GADBannerView = {
        let bannerView = GADBannerView()
        bannerView.adUnitID = "ca-app-pub-1480390762284051/8439011927" // Pro
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111" // Test
        if #available(iOS 13.0, *) {
            bannerView.backgroundColor = .secondarySystemBackground
        }
        return bannerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        view.addSubview(bannerView)
        descriptionLabel.text = ExtenStrings.descriptions.randomElement()
        if let name = UserDefaults.standard.string(forKey: ExtenStrings.kNameUser) {
            nameLabel.text = "Welcome \(name)"
        }
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setUserDefaultShowStamp),
            name: NSNotification.Name(rawValue: kDidBecomeActive),
            object: nil)
        getDateUser()
        addGestureImageBackground()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerView.frame = CGRect(x: 0, y: view.frame.height - 60, width: view.frame.size.width, height: 60).integral
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUserDefaultShowStamp()
        setupUILogo()
    }

    @IBAction func changeDescription(_ sender: Any) {
        descriptionLabel.text = ExtenStrings.descriptions.randomElement()
    }

    @IBAction func editName(_ sender: Any) {
        changeName()
    }

    @IBAction func tapFacebook(_ sender: Any) {
//        let standard = UserDefaults.standard
//        goldClearLogo = standard.integer(forKey: ExtenStrings.kClearLogo)
//        if standard.string(forKey: ExtenStrings.kDateToDay) == date {
//            addDateUser(dateString: App.region.today().toString(.date))
//            standard.set(date, forKey: ExtenStrings.kDateToDay)
//            let stamp = standard.integer(forKey: ExtenStrings.kStampToDate)
//            standard.set(stamp + 1, forKey: ExtenStrings.kStampToDate)
//            showStampPopup(nil, stamp: stamp + 1, dailyStamp: 1, animation: true) {
//                if stamp + 1 == 2 {
//                    standard.set(0, forKey: ExtenStrings.kStampToDate)
//                    standard.set(self.goldClearLogo + 1, forKey: ExtenStrings.kClearLogo)
//                    self.goldClearLogo = self.goldClearLogo + 1
//                    self.setupUILogo()
//                    let vc = PopupCongratsActionViewController()
//                    vc.modalPresentationStyle = .overFullScreen
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.delegate = self
//                    self.present(vc, animated: true)
//                }
//            }
//        }
        openFaceBook()
    }

    @IBAction func tapShowStamp(_ sender: Any) {
        let stamp = UserDefaults.standard.integer(forKey: ExtenStrings.kStampToDate)
        let vc = DisplayStampViewController()
        vc.totalStamp = stamp
        vc.isAnimation = false
        vc.gif = goldClearLogo
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }

    @IBAction func calendarTouchUp(_ sender: Any) {
        if !isShowingCalendar {
            showLifeLogCalendar2()
            isShowingCalendar = true
        }
    }

    @IBAction func tapEmail(_ sender: Any) {
        openMail()
    }

    @IBAction func actionTap(_ sender: Any) {
        let action = ActionPopupViewController()
        action.modalPresentationStyle = .overFullScreen
        action.modalTransitionStyle = .crossDissolve
        action.delegate = self
        present(action, animated: false)
    }

    func addGestureImageBackground() {
        if let image = loadImageFromUserDefaults() {
            // Hiển thị ảnh
            backgroundImage.image = image
        }
        backgroundImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        backgroundImage.addGestureRecognizer(tapGesture)
    }

    @objc func imageViewTapped() {
        // Handle the tap gesture on the image view
        showPhotoPicker()
    }

    func showPhotoPicker() {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 1

            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            choosePhoto(sourceType: .photoLibrary)
        }
    }

    // for < ios 14
    func choosePhoto(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }

    func saveImageToUserDefaults(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1) {
            UserDefaults.standard.set(imageData.base64EncodedString(), forKey: "SavedImage")
        }
    }

    // Hiển thị ảnh từ UserDefault
    func loadImageFromUserDefaults() -> UIImage? {
        if let savedImageString = UserDefaults.standard.string(forKey: "SavedImage"),
            let imageData = Data(base64Encoded: savedImageString),
            let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }

    func showGenQRCode() {
        let vc = EntryController()
        present(vc, animated: true)
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner Received")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Fail to receive ad with error: \(error)")
    }

    func changeName() {
        let alertController = UIAlertController(title: "You can change your name.", message: nil, preferredStyle: .alert)

        // Add a text field to the alert controller
        alertController.addTextField { textField in
            textField.placeholder = "Enter your name...."
            if let name = UserDefaults.standard.string(forKey: ExtenStrings.kNameUser) {
                textField.text = "\(name)"
            }
        }

        // Add an action button to the alert controller
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = alertController.textFields?.first {
                let enteredText = textField.text ?? ""
                UserDefaults.standard.set(enteredText, forKey: ExtenStrings.kNameUser)
                self.nameLabel.text = "Welcome \(enteredText)"
            }
        }
        alertController.addAction(okAction)

        // Add a cancel button to the alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
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

    @objc func setUserDefaultShowStamp() {
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

extension WelcomeViewController: ActionPopupViewControllerDelegate {
    func controller(_ controller: ActionPopupViewController, needPerformAction action: ActionPopupViewController.Action) {
        switch action {
        case .game:
            let vc = MainGameViewController()
            let navi = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.first?.rootViewController = navi
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        case .generate:
            let vc = EntryController()
            let navi = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.first?.rootViewController = navi
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        case .combineImage:
            let vc = EditorImageViewController()
            let navi = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.first?.rootViewController = navi
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}

class ContactLinkMailManager {

    // MARK: - Send Email / Message
    class func createControllerEmail(delegate: MailDelegate) -> UIViewController? {
        let address = "haily.211194@gmail.com"

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

extension WelcomeViewController: PHPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard !results.isEmpty else {
            return
        }

        let itemProvider = results[0].itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let this = self else { return }
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        // Use the selected image
                        this.saveImageToUserDefaults(image: image)
                        this.backgroundImage.image = image
                    }
                }
            }
        }
    }
}

extension WelcomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Xử lý ảnh đã chọn hoặc chụp tại đây
            backgroundImage.image = pickedImage
            saveImageToUserDefaults(image: pickedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
