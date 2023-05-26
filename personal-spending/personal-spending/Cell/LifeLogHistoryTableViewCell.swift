//
//  LifeLogHistoryTableViewCell.swift
//  CM
//
//  Created by NganHa on 1/11/21.
//  Copyright © 2021 AsianTech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils

final class LifeLogHistoryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var memoLabel: UILabel!
    @IBOutlet private weak var secondLineImageView: UIImageView!

    // calorie
    @IBOutlet private weak var calorieConsumpLabel: UILabel!
    @IBOutlet private weak var calorieIntakeLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!

    // image calorie
    @IBOutlet private weak var calorieConsumptView: UIView!
    @IBOutlet private weak var calorieIntakeView: UIView!

    // memo no input
    @IBOutlet private weak var memoNoInputLabel: UILabel!
    @IBOutlet private weak var kcalUnitConsump: UILabel!
    @IBOutlet private weak var kcalUnitIntake: UILabel!
    @IBOutlet private weak var unitScoreLabel: UILabel!

    // MARK: - Propeties
    var viewModel: LifeLogHistoryTableViewCellViewModel! {
        didSet {
            updateUI()
            showImageView()
//            setNeedsLayout()
//            layoutIfNeeded()
        }
    }

    private var x: CGFloat = 0
    // MARK: - Initialize

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Override functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Private functions
    private func configUI() {
//r
    }

    private func resetUI() {
        kcalUnitConsump.isHidden = true
        kcalUnitIntake.isHidden = true
        unitScoreLabel.isHidden = true

        scoreLabel.text = nil
        calorieIntakeLabel.text = nil
        calorieConsumpLabel.text = nil

        calorieIntakeView.isHidden = true
        calorieConsumptView.isHidden = true

        memoLabel.isHidden = true
        secondLineImageView.isHidden = true

        memoLabel.text = nil
        dayLabel.text = nil
        dayOfWeekLabel.text = nil
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        memoLabel.isHidden = viewModel.memoLabelIsHidden
        memoLabel.text = "viewModel.getMemo().value"
        dayLabel.text = "23-5"
        dayOfWeekLabel.text = "24-5"
        calorieConsumpLabel.text = "viewModel.convertCalorieDecimal(caloCons"
        calorieIntakeLabel.text = "viewModel.convertCalorieDecimal(caloIntake ?? 0)"
        scoreLabel.text = "String(score ?? 0)"

        calorieConsumpLabel.isHidden = viewModel.caloConsumpIsHidden
        calorieIntakeLabel.isHidden = viewModel.caloIntakeIsHidden
        scoreLabel.isHidden = viewModel.totalScoreIsHidden
        calorieConsumptView.isHidden = viewModel.caloConsumpIsHidden
        calorieIntakeView.isHidden = viewModel.caloIntakeIsHidden
        kcalUnitConsump.isHidden = viewModel.caloConsumpIsHidden
        kcalUnitIntake.isHidden = viewModel.caloIntakeIsHidden
        unitScoreLabel.isHidden = viewModel.totalScoreIsHidden

        memoNoInputLabel.isHidden = !viewModel.isAllHidden
        secondLineImageView.isHidden = viewModel.isAllHidden
    }

    private func showImageView() {
    }

    private func setUpNoInput(id: Int) {
    }

    private func setUpMealWithoutImage() {
    }

    private func setUpMealWithImage() {
    }

    private func hideNoImageAndFoodLabel(_ foodLabel: UILabel, _ image: UIImageView) {
        foodLabel.isHidden = true
        image.isHidden = true
    }
}
