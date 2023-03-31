//
//  FoodCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        self.foodImageView.backgroundColor = UIColor.signatureSkyBlue
        self.foodImageView.layer.cornerRadius = self.foodImageView.frame.width / 2
    }

}
