//
//  PopupCongratsActionViewController.swift
//  RENA
//
//  Created by ly.truong on 8/17/18.
//

import UIKit
import SwiftUtils

protocol PopupCongratsActionViewControllerDelegate: class {
    func controller(_ controller: PopupCongratsActionViewController, needPerform action: PopupCongratsActionViewController.Action)
}

class PopupCongratsActionViewController: UIViewController {
    
    enum Action {
        case dismiss
    }


    @IBOutlet fileprivate weak var popupImageView: UIImageView!
    @IBOutlet fileprivate weak var borderPointView: UIView!
    @IBOutlet fileprivate weak var conerLevelView: UIView!
    @IBOutlet fileprivate weak var levelLabel: UILabel!
    @IBOutlet fileprivate weak var textLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var contentPopupView: UIView!
    
    weak var delegate: PopupCongratsActionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.overlay
        configUI()
    }

    func configUI() {
        contentPopupView.corner = 7
    }

    @IBAction func achieveTarget(_ sender: Any) {
        dismiss(animated: true)
        delegate?.controller(self, needPerform: .dismiss)
    }
}

// MARK: - Defination
extension PopupCongratsActionViewController {

    struct Define {
        static let cellHeight: CGFloat = 50
    }
}
