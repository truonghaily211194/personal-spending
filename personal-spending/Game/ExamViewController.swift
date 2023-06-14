//
//  ExamViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 14/06/2023.
//

import UIKit

class ExamViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questionBackground: UIView!
    @IBOutlet weak var questionsCountLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerResultImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomImage: UIImageView!
    
    private let examModel = ExamModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tuneUI()
        examModel.testStart()
        examModel.test(questionLabel: questionLabel, buttons: nil, countLabel: questionsCountLabel)
        if examModel.examEmpty {
            showAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentResult(_:)), name: Notification.Name(rawValue: examResultNotificationKey), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Please complete 3 final exams first", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    @objc private func presentResult(_ notification: NSNotification) {
        if let result = notification.object {
            let alert = UIAlertController(title: "Your result: \(result)%", message: nil, preferredStyle: .alert)
            
            let backAction = UIAlertAction(title: "Go Menu", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            let onceAgainAction = UIAlertAction(title: "Try one more time", style: .cancel) {_ in
                self.examModel.testStart()
                self.examModel.test(questionLabel: self.questionLabel, buttons: nil, countLabel: self.questionsCountLabel)
            }
            alert.addAction(backAction)
            alert.addAction(onceAgainAction)
            
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        examModel.resetResults()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func tuneUI() {
        questionBackground.layer.cornerRadius = 20
        if #available(iOS 13.0, *) {
            questionBackground.layer.borderColor = CGColor(red: 250 / 255, green: 185 / 255, blue: 26 / 255, alpha: 1)
        } else {
            // Fallback on earlier versions
            questionBackground.layer.borderColor = UIColor.systemPink.cgColor
        }
        questionBackground.layer.borderWidth = 5
        
        questionLabel.textColor = UIColor(red: 54 / 255, green: 63 / 255, blue: 242 / 255, alpha: 1)
        questionLabel.adjustsFontSizeToFitWidth = true
        
        answerResultImage.isHidden = true
        
        textField.delegate = self
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        
        bottomImage.image = UIImage(named: "enjoy-60")
    }
}

extension ExamViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        examModel.userAnswer = textField.text
        if examModel.isRightAnswerCheck() {
            answerResultImage.image = UIImage(named: "Right_png")
            questionLabel.isHidden = true
            answerResultImage.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] _ in
                examModel.nextQuestion()
                examModel.test(questionLabel: questionLabel, buttons: nil, countLabel: questionsCountLabel)
                answerResultImage.isHidden = true
                questionLabel.isHidden = false
            }
        } else {
            answerResultImage.image = UIImage(named: "Wrong_png")
            questionLabel.isHidden = true
            answerResultImage.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] _ in
                examModel.nextQuestion()
                examModel.test(questionLabel: questionLabel, buttons: nil, countLabel: questionsCountLabel)
                answerResultImage.isHidden = true
                questionLabel.isHidden = false
            }
        }
        textField.text = ""
        return true
    }
    
}
