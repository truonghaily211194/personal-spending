//
//  ActionPopupViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 19/06/2023.
//

import UIKit

class ActionPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_:)))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc private func handleDismiss(_ sender: Any?) {
       dismiss(animated: true)
    }
}
