//
//  KitCollectionViewCell.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 13/06/2023.
//

import UIKit

class KitCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tuneUI()
    }
    
    private func tuneUI() {
        background.backgroundColor = UIColor(red: 1, green: 220 / 255, blue: 199 / 255, alpha: 1)
        self.layer.cornerRadius = 20
        label.adjustsFontSizeToFitWidth = true
    }
}
