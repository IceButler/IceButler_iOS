//
//  FoodCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import UIKit
import Combine
import Kingfisher

class FoodCell: UICollectionViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDdayLabel: UILabel!
    
    var cancellabels: Set<AnyCancellable> = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellabels.removeAll()
    }
    
    private func setupLayout() {
        foodImageView.layer.cornerRadius = foodImageView.frame.width / 2
    }
    
    func setFoodName(foodName: String) {
        foodNameLabel.text = foodName
    }
    
    func setDday(foodDday: String) {
        foodDdayLabel.text = foodDday
    }
    
    func setFoodImage(foodImage: String) {
        if let url = URL(string: foodImage) {
            foodImageView.kf.setImage(with: url)
        }
    }

}
