//
//  FooterMainGameView.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 14/06/2023.
//

import UIKit

protocol FooterMainGameViewDelegate: class {
    func footerView(footer: FooterMainGameView, needPerformAction action: FooterMainGameView.Action)
}

class FooterMainGameView: UITableViewHeaderFooterView {
    
    enum Action {
        case exam(Int)
    }

    @IBOutlet weak var footerLabel: UILabel!
    weak var delegate: FooterMainGameViewDelegate?
    
    var footerText: String = "" {
        didSet {
            footerLabel.text = footerText
        }
    }
    
    var section: Int = 0
    

    @IBAction func clickExam(_ sender: Any) {
        delegate?.footerView(footer: self, needPerformAction: .exam(section))
    }
}
