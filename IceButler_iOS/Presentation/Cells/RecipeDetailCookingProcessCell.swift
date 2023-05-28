//
//  RecipeDetailCookingProcessCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/22.
//

import UIKit

class RecipeDetailCookingProcessCell: UITableViewCell {

    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var cookeryImageView: UIImageView!
    @IBOutlet var descriptionTrailingConstarintToSuperView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        cookeryImageView.layer.cornerRadius = 10
        cookeryImageView.layer.masksToBounds = true
    }
    
    func configure(stepNum: Int, description: String, cookeryImgUrl: String?) {
        stepLabel.text = "0\(stepNum)"
        descriptionLabel.text = description
        if let cookeryImgUrl = cookeryImgUrl {
            if let url = URL(string: cookeryImgUrl) {
                cookeryImageView.isHidden = false
                cookeryImageView.kf.setImage(with: url)
                cookeryImageView.contentMode = .scaleAspectFill
            }
        } else {
            cookeryImageView.isHidden = true
            descriptionTrailingConstarintToSuperView.priority = UILayoutPriority(1000)
        }
    }
}
