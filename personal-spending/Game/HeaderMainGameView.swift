//
//  HeaderMainGameView.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 14/06/2023.
//

import UIKit

class HeaderMainGameView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerLabel: UILabel!
    
    var headerText: String = "" {
        didSet {
            headerLabel.text = headerText
        }
    }
    
}
