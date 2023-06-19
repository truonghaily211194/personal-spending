//
//  MainGameViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 13/06/2023.
//

import UIKit
import GoogleMobileAds

class MainGameViewController: UIViewController, GADFullScreenContentDelegate {

    struct DataCourseCell {
        let image: UIImage
        let name: String
        let tag: Int
    }

    struct DataSection {
        let nameSection: String
        let dataCell: [DataCourseCell]
    }

    @IBOutlet weak var tableView: UITableView!

    private let mainGameModel = MainGameModel()
    let course: [Int] = [0, 1, 2, 3, 4]
    let finalCourse: [Int] = [5, 6, 7]
    let exam: [Int] = [0, 1, 2, 3, 4]
    let data: [DataSection] = [DataSection(nameSection: "Newborn", dataCell: [DataCourseCell(image: UIImage(named: "Baby_png") ?? UIImage(), name: "Newborn", tag: 0)]),
        DataSection(nameSection: "PreSchool", dataCell: [DataCourseCell(image: UIImage(named: "Girl_png") ?? UIImage(), name: "PreSchool", tag: 1)]),
        DataSection(nameSection: "Early School", dataCell: [DataCourseCell(image: UIImage(named: "Backpack_png") ?? UIImage(), name: "Early School", tag: 2)]),
        DataSection(nameSection: "High School", dataCell: [DataCourseCell(image: UIImage(named: "Graduation_png") ?? UIImage(), name: "High School", tag: 3), DataCourseCell(image: UIImage(named: "ChartIncreasing_png") ?? UIImage(), name: "Life Activities", tag: 4)]),
        DataSection(nameSection: "Final Exam", dataCell: [DataCourseCell(image: UIImage(named: "Programming_png") ?? UIImage(), name: "Programming University", tag: 5), DataCourseCell(image: UIImage(named: "Construction_png") ?? UIImage(), name: "Construction University", tag: 6), DataCourseCell(image: UIImage(named: "Money_png") ?? UIImage(), name: "Side jobs", tag: 7)])
    ]

    // 0 ->7 : 8course
    // 0->4: 5 exam
    
//    private var interstitial: GADInterstitialAd?
//
//    let adsTest = "ca-app-pub-3940256099942544/1033173712"
//    let adsPro = "ca-app-pub-1480390762284051/6778284194"


    override func viewDidLoad() {
        super.viewDidLoad()
        // Todo: -
//        requestAds()
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.shadowColor = .clear
            appearance.backgroundColor = UIColor.white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor.RGB(246, 246, 246)
        }
        title = "Main Game"

        let backButton = UIBarButtonItem(title: "BackHome", style: .plain, target: self, action: #selector(backButtonTapped))
        // Assign the custom button to the leftBarButtonItem
        navigationItem.leftBarButtonItem = backButton

        tableView.register(MainGameCell.self)
        tableView.register(HeaderMainGameView.self)
        tableView.register(FooterMainGameView.self)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        exam.forEach { button in
            if mainGameModel.examAccessControl(for: button) {
                if UserData.shared.getUserResult(for: StudyStage.getExamName(studyStage: button)) >= 50 {
                    UserData.shared.saveExamCompletion(for: button)
                }
            } else {
            }
        }

        course.forEach { button in
            if mainGameModel.studyStageAccessControl(for: button) {
//                button.alpha = 1
            } else {
//                button.alpha = 0.5
            }
        }

//        finalCourse.forEach { button in
//            button.restorationIdentifier = UserData.shared.getStageSelection(for: button.tag)
//            if button.restorationIdentifier == "Unselected" {
//                if mainStoryModel.studyStageAccessControl(for: button.tag) {
//                    button.backgroundColor = UIColor(red: 1, green: 200 / 255, blue: 199 / 255, alpha: 1)
//                    button.tintColor = .black
//                    button.alpha = 1
//                } else {
//                    button.alpha = 0.5
//                    button.backgroundColor = .clear
//                    button.tintColor = UIColor(red: 1, green: 200 / 255, blue: 199 / 255, alpha: 1)
//                }
//            } else {
//                button.backgroundColor = .clear
//                button.tintColor = UIColor(red: 1, green: 200 / 255, blue: 199 / 255, alpha: 1)
//            }
//        }

//        if mainGameModel.examAccessControl(for: 0) {
//            if UserData.shared.getUserResult(for: StudyStage.getExamName(studyStage: 0)) >= 50 {
//                UserData.shared.saveExamCompletion(for: 0)
//            }
////            button.restorationIdentifier = UserData.shared.getExamCompletion(for: 0)
//        } else {
////            button.alpha = 0.5
//        }
    }
    
//    func requestAds() {
//        let request = GADRequest()
//        GADInterstitialAd.load(withAdUnitID: adsTest,
//            request: request,
//            completionHandler: { [self] ad, error in
//                if let error = error {
//                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                    return
//                }
//                interstitial = ad
//            interstitial?.fullScreenContentDelegate = self
//            }
//        )
//    }
    
//    func showAds() {
//        if interstitial != nil {
//            interstitial?.present(fromRootViewController: self)
//          } else {
//            print("Ad wasn't ready")
//          }
//    }
    
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad will present full screen content.
      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }

    @objc func backButtonTapped() {
        let vc = WelcomeViewController()
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    @IBAction func tapCourse(_ sender: Any) {
        let vc = KitSelectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainGameViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCell = data[section].dataCell
        return dataCell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MainGameCell.self)
        let item = data[indexPath.section].dataCell[indexPath.row]
        cell.course = item.name
        cell.image = item.image
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeue(HeaderMainGameView.self)
        header.headerText = data[section].nameSection
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeue(FooterMainGameView.self)
        footer.footerText = "Exam"
        footer.section = section
        footer.delegate = self
        return footer
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Todo: -
//        showAds()
        let vc = KitSelectionViewController()
        let data = data[indexPath.section].dataCell[indexPath.row]
        if data.tag > 4 {
            UserData.shared.saveStageSelection(for: indexPath.row)
        }
        vc.studyStageRawValue = data.tag
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainGameViewController: FooterMainGameViewDelegate {
    func footerView(footer: FooterMainGameView, needPerformAction action: FooterMainGameView.Action) {
        switch action {
        case .exam(let section):
            // Todo: -
//            showAds()
            let vc = ExamViewController()
            NotificationCenter.default.post(name: Notification.Name(rawValue: chosenExamNotificationKey), object: section)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


}
