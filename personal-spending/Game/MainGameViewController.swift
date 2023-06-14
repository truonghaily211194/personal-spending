//
//  MainGameViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 13/06/2023.
//

import UIKit

class MainGameViewController: UIViewController {
    
    private let mainGameModel = MainGameModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mainGameModel.examAccessControl(for: 0) {
//            button.alpha = 1
            if UserData.shared.getUserResult(for: StudyStage.getExamName(studyStage: 0)) >= 50 {
                UserData.shared.saveExamCompletion(for: 0)
            }
//            button.restorationIdentifier = UserData.shared.getExamCompletion(for: 0)
        } else {
//            button.alpha = 0.5
        }
    }

    @IBAction func tapCourse(_ sender: Any) {
        let vc = KitSelectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
