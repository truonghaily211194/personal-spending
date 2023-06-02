//
//  TestTableViewCell.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 31/05/2023.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    @IBOutlet weak var moneyLabel: UILabel!
    
    var money: String = "" {
        didSet {
            moneyLabel.text = money
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
