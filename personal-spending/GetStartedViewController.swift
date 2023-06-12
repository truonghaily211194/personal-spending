//
//  GetStartedViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 12/06/2023.
//

import UIKit

class GetStartedViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var startedButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func GetStarted(_ sender: Any) {
        if let text = nameTextField.text {
            UserDefaults.standard.set(text, forKey: ExtenStrings.kNameUser)
        }
        UserDefaults.standard.set(true, forKey: ExtenStrings.kChangeRoot)
        let vc = WelcomeViewController()
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Calculate the resulting text if the replacement is made
        guard let text = textField.text else {
            return true
        }

        let updatedText = (text as NSString).replacingCharacters(in: range, with: string)

        // Validate the length of the text
        return updatedText.count <= 20
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when the return key is pressed
        textField.resignFirstResponder()
        return true
    }
}
