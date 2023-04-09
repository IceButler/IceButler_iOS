//
//  foodAddImageCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/08.
//

import UIKit

class FoodAddImageCell: UICollectionViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodImageAddImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: UIImage) {
        foodImageView.image = image
    }
    
    
    func hiddenFoodImageAddIcon() {
        foodImageAddImageView.isHidden = true
    }

}
