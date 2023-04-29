//
//  FoodCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit
import Combine
import Kingfisher

protocol FoodCellDelegate {
     func setEditMode(edit: Bool)
     func deleteFoodsAction(index: Int, row: Int)
 }

class FoodCollectionViewCell: UICollectionViewCell {

    var isSelectedFood: Bool = false
    var cancellabels: Set<AnyCancellable> = []
    
    @IBOutlet weak var foodImageButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        cancellabels.removeAll()
//        self.isSelectedFood = false
//    }
    
    
    private func setupGestureHandler() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        longPressGesture.minimumPressDuration = 1
        self.foodImageButton.addGestureRecognizer(longPressGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        self.foodImageButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        self.foodImageButton.backgroundColor = UIColor.signatureSkyBlue
        self.foodImageButton.layer.cornerRadius = self.foodImageButton.frame.width / 2
        
        self.foodImageButton.backgroundColor = .signatureSkyBlue
        self.selectedImageView.isHidden = true
    }
    
    func setFoodName(foodName: String) {
        self.foodTitleLabel.text = foodName
    }
    
    func setFoodImg(foodImg: String) {
        let url = URL(string: foodImg)
        self.foodImageButton.kf.setImage(with: url, for: .normal)
    }
    
    public func configure(name: String) {
        self.isSelectedFood = false
        self.foodTitleLabel.text = name
        setupGestureHandler()
        setupLayout()
    }
    
    public func setData(data: CartFood) {
        if let _ = data.foodImgUrl,
           let _ = data.foodName {
            
            let url = URL(string: data.foodImgUrl!)
            self.foodImageButton.kf.setImage(with: url, for: .normal)
            
            self.isSelectedFood = false
            self.foodTitleLabel.text = data.foodName
        }
        setupGestureHandler()
        setupLayout()
    }
    
    @objc func longPressAction(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == UIGestureRecognizer.State.began {
            self.isSelectedFood = !self.isSelectedFood
            if self.isSelectedFood {
                self.foodImageButton.backgroundColor = .signatureDustBlue
                self.selectedImageView.isHidden = false
                CartViewModel.shared.showCartVCAlertView()
                CartViewModel.shared.addRemoveIdx(removeIdx: self.tag, removeName: self.foodTitleLabel.text!)
            }
        }
    }
    
    @objc func tapAction(_ guesture: UITapGestureRecognizer) {
        if self.isSelectedFood {
            self.foodImageButton.backgroundColor = .signatureSkyBlue
            self.selectedImageView.isHidden = true
            CartViewModel.shared.removeRemoveIdx(removeIdx: self.tag)
            
            if CartViewModel.shared.removeFoodIdxes?.count == 0 {
                CartViewModel.shared.showCartCVTabBar()
            }
            
        } else {
            if CartViewModel.shared.removeFoodIdxes?.count ?? 0 > 0 {
                self.foodImageButton.backgroundColor = .signatureDustBlue
                self.selectedImageView.isHidden = false
                CartViewModel.shared.addRemoveIdx(removeIdx: self.tag, removeName: self.foodTitleLabel.text!)
            }
        }
        self.isSelectedFood = !self.isSelectedFood
    }
    
    func setSelect() {
        self.isSelectedFood = !self.isSelectedFood
        if self.isSelectedFood  {
            self.foodImageButton.backgroundColor = .signatureSkyBlue
            self.selectedImageView.isHidden = true
            CartViewModel.shared.removeRemoveIdx(removeIdx: self.tag)
        }
        else { CartViewModel.shared.addRemoveIdx(removeIdx: self.tag, removeName: self.foodTitleLabel.text!) }
    }
}
