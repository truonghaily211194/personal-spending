//
//  ActionPopupViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 19/06/2023.
//

import UIKit

protocol ActionPopupViewControllerDelegate: class {
    func controller(_ controller: ActionPopupViewController, needPerformAction action: ActionPopupViewController.Action)
}

class ActionPopupViewController: UIViewController {

    enum Action {
        case game
        case generate
        case combineImage
    }
    
    weak var delegate: ActionPopupViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_:)))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc private func handleDismiss(_ sender: Any?) {
       dismiss(animated: true)
    }
    
    @IBAction func tapGame(_ sender: Any) {
        delegate?.controller(self, needPerformAction: .game)
    }
    
    @IBAction func generateQR(_ sender: Any) {
        delegate?.controller(self, needPerformAction: .generate)
    }

    @IBAction func combineImages(_ sender: Any) {
        delegate?.controller(self, needPerformAction: .combineImage)
    }
}
