//
//  foodAddImageCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/08.
//

import UIKit
import Kingfisher

class FoodAddImageCell: UICollectionViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodImageAddImageView: UIImageView!
    
    override func awakeFromNib() {
        setupLayout()
        super.awakeFromNib()
    }
    
    private func setupLayout() {
        foodImageView.layer.cornerRadius = 10
    }
    
    func configure(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            foodImageView.kf.setImage(with: url)
            hiddenFoodImageAddIcon()
        }else {
            foodImageView.image = nil
        }
    }
    
    func setImage(image: UIImage) {
        foodImageView.image = image
        hiddenFoodImageAddIcon()
    }
    
    
    func hiddenFoodImageAddIcon() {
        foodImageAddImageView.isHidden = true
    }

    func showFoodImageAddIcon() {
        foodImageAddImageView.isHidden = false
    }
}
