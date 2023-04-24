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
        super.awakeFromNib()
    }
    
    func configure(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            foodImageView.kf.setImage(with: url)
        }
    }
    
    func setImage(image: UIImage) {
        foodImageView.image = image
    }
    
    
    func hiddenFoodImageAddIcon() {
        foodImageAddImageView.isHidden = true
    }

}
