//
//  MainGameViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 13/06/2023.
//

import UIKit

class MainGameViewController: UIViewController {
    
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
    let data: [DataSection] = [DataSection(nameSection: "Newborn", dataCell: [DataCourseCell(image: UIImage(named: "") ?? UIImage(), name: "Newborn", tag: 0)]),
        DataSection(nameSection: "PreSchool", dataCell: [DataCourseCell(image: UIImage(named: "") ?? UIImage(), name: "PreSchool", tag: 1)]),
                               DataSection(nameSection: "Early School", dataCell: [DataCourseCell(image: UIImage(named: "") ?? UIImage(), name: "Early School", tag: 2)]),
                               DataSection(nameSection: "High School", dataCell: [DataCourseCell(image: UIImage(named: "") ?? UIImage(), name: "High School", tag: 3), DataCourseCell(image: UIImage(named: "") ?? UIImage(), name: "Life Activities", tag: 4)]),
                               DataSection(nameSection: "Final Exam", dataCell: [DataCourseCell(image: UIImage(named: "") ?? UIImage(), name: "Programming University", tag: 5), DataCourseCell(image: UIImage(named: "") ?? UIImage(), name: "Construction University", tag: 6), DataCourseCell(image: UIImage(named: "") ?? UIImage(), name: "Side jobs", tag: 7)])
    ]
    
    // 0 ->7 : 8course
    // 0->4: 5 exam
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(MainGameCell.self)
        tableView.register(HeaderMainGameView.self)
        tableView.register(FooterMainGameView.self)
        tableView.delegate = self
        tableView.dataSource = self
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
        let vc = KitSelectionViewController()
        let data = data[indexPath.section].dataCell[indexPath.row]
        vc.studyStageRawValue = data.tag
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainGameViewController: FooterMainGameViewDelegate {
    func footerView(footer: FooterMainGameView, needPerformAction action: FooterMainGameView.Action) {
        switch action {
        case .exam(let section):
            print("---------: \(section)")
        }
    }
    
    
}
