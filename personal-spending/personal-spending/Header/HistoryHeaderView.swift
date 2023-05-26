//
//  HistoryHeaderView.swift
//  CM
//
//  Created by NganHa on 1/15/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import UIKit

final class HistoryHeaderView: UITableViewHeaderFooterView {

    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Propeties
    var viewModel: HistoryHeaderViewModel? {
        didSet {
            updateUI()
        }
    }
    // MARK: - Initialize
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Private functions
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
    }

    // MARK: - Public functions
}
