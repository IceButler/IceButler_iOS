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
    @IBOutlet var selectedImageView: UIImageView!
    
    private var foodIdx: Int?
    
    var cancellabels: Set<AnyCancellable> = []
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
        setupLayout()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellabels.removeAll()
    }
    
    private func setup() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGestureAction))
        longGesture.minimumPressDuration = 1
        self.addGestureRecognizer(longGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction))
        
        FoodViewModel.shared.isSelectedFood { isSelectedFood in
            if isSelectedFood {
                self.addGestureRecognizer(tapGesture)
            }else {
                self.removeGestureRecognizer(tapGesture)
            }
        }
        
        self.selectedImageView.isHidden = true
        
        FoodViewModel.shared.isSelectedFood { result in
            if result == false {
                self.selectedImageView.isHidden = true
            }
        }
    }
    
    private func setupLayout() {
        foodImageView.backgroundColor = UIColor(red: 196 / 255, green: 232 / 255, blue: 169 / 255, alpha: 0.3)
        foodImageView.layer.cornerRadius = foodImageView.frame.width / 2
    }
    
    
    @objc private func longGestureAction() {
        if FoodViewModel.shared.getIsSelectedFood() == false {
            if let foodIdx = self.foodIdx {
                if FoodViewModel.shared.tapDeleteFoodIdx(foodIdx: foodIdx) {
                    self.selectedImageView.isHidden = false
                    FoodViewModel.shared.setIsSelectedFood(isSelected: true)
                }else {
                    self.selectedImageView.isHidden = true
                }
            }
        }
    }
    
    @objc private func tapGestureAction() {
        if FoodViewModel.shared.getIsSelectedFood() {
            if let foodIdx = self.foodIdx {
                if FoodViewModel.shared.tapDeleteFoodIdx(foodIdx: foodIdx) {
                    self.selectedImageView.isHidden = false
                }else {
                    self.selectedImageView.isHidden = true
                }
            }
        }
    }
    
    
    func setFoodName(foodName: String) {
        foodNameLabel.text = foodName
    }
    
    func setDday(foodDday: Int) {
        if foodDday > 0 {
            foodDdayLabel.text = "D+" + foodDday.description
        }else if foodDday == 0 {
            foodDdayLabel.text = "D-" + foodDday.description
        }else {
            foodDdayLabel.text = "D" + foodDday.description
        }
        
    }
    
    func setFoodImage(foodImage: String) {
        if let url = URL(string: foodImage) {
            foodImageView.kf.setImage(with: url)
        }
    }
    
    func setFoodIdx(foodIdx: Int) {
        self.foodIdx = foodIdx
    }

}
