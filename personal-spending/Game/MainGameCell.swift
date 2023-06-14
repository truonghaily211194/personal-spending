//
//  MainGameCell.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 14/06/2023.
//

import UIKit

class MainGameCell: UITableViewCell {

    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var course: String = "" {
        didSet {
            courseLabel.text = course
        }
    }
    
    var image: UIImage = UIImage() {
        didSet {
            iconImage.image = image
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
