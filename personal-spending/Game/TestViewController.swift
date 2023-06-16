//
//  TestViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 13/06/2023.
//

import UIKit
import GoogleMobileAds

class TestViewController: UIViewController {

    @IBOutlet weak var rootView: UIView!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet weak var answerResultImage: UIImageView!
    @IBOutlet weak var questionsCountLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionBackground: UIView!

    private let testingModel = TestingModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tuneUI()
        testingModel.testStart()
        testingModel.test(questionLabel: questionLabel, buttons: answerButtons, countLabel: questionsCountLabel)
        if testingModel.questionEmpty {
            showAlert()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(presentResult(_:)), name: Notification.Name(rawValue: testNotificationKey), object: nil)
    }

    func showAlert() {
        let alert = UIAlertController(title: "Please choose another course", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    @objc func presentResult(_ notification: NSNotification) {
        if let result = notification.object {
            let alert = UIAlertController(title: "Your result: \(result)%", message: nil, preferredStyle: .alert)

            let backAction = UIAlertAction(title: "Go to main menu", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            let onceAgainAction = UIAlertAction(title: "Try one more time", style: .cancel) { _ in
                self.testingModel.testStart()
                self.testingModel.test(questionLabel: self.questionLabel, buttons: self.answerButtons, countLabel: self.questionsCountLabel)
            }
            alert.addAction(backAction)
            alert.addAction(onceAgainAction)

            self.present(alert, animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        testingModel.resetResults()
        NotificationCenter.default.removeObserver(self)
    }

    private func tuneUI() {
        questionBackground.layer.cornerRadius = 20
        if #available(iOS 13.0, *) {
            questionBackground.layer.borderColor = CGColor(red: 250 / 255, green: 185 / 255, blue: 26 / 255, alpha: 1)
        } else {
            questionBackground.layer.borderColor = UIColor.systemPink.cgColor
            // Fallback on earlier versions
        }
        questionBackground.layer.borderWidth = 5

        questionLabel.textColor = UIColor(red: 54 / 255, green: 63 / 255, blue: 242 / 255, alpha: 1)
        questionLabel.adjustsFontSizeToFitWidth = true

        answerResultImage.isHidden = true

        for button in answerButtons {
            button.layer.cornerRadius = 20
            button.backgroundColor = UIColor(red: 54 / 255, green: 63 / 255, blue: 242 / 255, alpha: 1)
            button.titleLabel?.numberOfLines = 3
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.textAlignment = .center
        }
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 246 / 255, green: 166 / 255, blue: 165 / 255, alpha: 1)
        testingModel.userAnswer = sender.titleLabel?.text
        rootView.isUserInteractionEnabled = false
        if testingModel.isRightAnswerCheck() {
//            questionLabel.isHidden = true
            answerResultImage.image = UIImage(named: "Right_png")
            answerResultImage.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] _ in
                testingModel.nextQuestion()
                testingModel.test(questionLabel: questionLabel, buttons: answerButtons, countLabel: questionsCountLabel)
                sender.backgroundColor = UIColor(red: 54 / 255, green: 63 / 255, blue: 242 / 255, alpha: 1)
                answerResultImage.isHidden = true
                questionLabel.isHidden = false
                rootView.isUserInteractionEnabled = true
            }
        } else {
            answerResultImage.image = UIImage(named: "Wrong_png")
//            questionLabel.isHidden = true
            answerResultImage.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] _ in
                testingModel.nextQuestion()
                testingModel.test(questionLabel: questionLabel, buttons: answerButtons, countLabel: questionsCountLabel)
                sender.backgroundColor = UIColor(red: 54 / 255, green: 63 / 255, blue: 242 / 255, alpha: 1)
                answerResultImage.isHidden = true
                questionLabel.isHidden = false
                rootView.isUserInteractionEnabled = true
            }
        }
    }
}
