//
//  FoodCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import UIKit

class FoodCell: UICollectionViewCell {
    
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDdayLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    
    
    private func setupLayout() {
        foodImageView.layer.cornerRadius = foodImageView.frame.width / 2
    }
    
    func configure(foodName: String, foodDday: String) {
        foodNameLabel.text = foodName
        foodDdayLabel.text = foodDday
    }

}
