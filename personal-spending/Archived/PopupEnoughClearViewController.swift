//
//  PopupEnoughClearViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 09/06/2023.
//

import UIKit

class PopupEnoughClearViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.overlay
        contentView.corner = 7
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doNotContact(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func contactFB(_ sender: Any) {
    }
    
    @IBAction func contactEmail(_ sender: Any) {
    }
}
