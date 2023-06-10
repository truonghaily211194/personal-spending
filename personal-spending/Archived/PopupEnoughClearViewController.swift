//
//  PopupEnoughClearViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 09/06/2023.
//

import UIKit
import MessageUI

class PopupEnoughClearViewController: UIViewController, MailDelegate {
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
        openFaceBook()
    }
    
    @IBAction func contactEmail(_ sender: Any) {
        openMail()
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
}

extension PopupEnoughClearViewController {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
