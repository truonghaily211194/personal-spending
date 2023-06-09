//
//  LifeLogCalendarCollectionCell.swift
//  CM
//
//  Created by MBP0039 on 5/17/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils

final class LifeLogCalendarCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var dateTitleLabel: UILabel!

    var viewModel: LifeLogCalendarCollectionCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = contentView.frame.size.width / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateTitleLabel.text = ""
        contentView.layer.borderWidth = 0
    }

    private func updateUI() {
        guard let dateItem = viewModel?.dateItem, let dateNumber = dateItem.date?.day else { return }
        dateTitleLabel.text = "\(dateNumber)"

        switch dateItem.dateStatus {
        case .indate(let type):
            switch type {
            case .current, .pass:
                dateTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
                dateTitleLabel.textColor = Color.Text.mainText
            case .future:
                dateTitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
                dateTitleLabel.textColor = Color.Text.placeholder
            }

            if true {
                contentView.layer.borderColor = LifeLogCalendarViewModel.ScoreLevel.from1To49.color?.cgColor ?? .none
            } else {
                contentView.layer.borderColor = UIColor.clear.cgColor
            }

            contentView.isHidden = false
        case .outdate:
            dateTitleLabel.font = UIFont.systemFont(ofSize: 17)
            dateTitleLabel.tintColor = UIColor.gray
            contentView.isHidden = true
        }
    }
}
