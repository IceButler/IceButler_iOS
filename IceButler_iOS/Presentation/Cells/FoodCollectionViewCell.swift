//
//  FoodCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit
import Combine

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
        setupGestureHandler()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellabels.removeAll()
    }
    
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
    }
    
    @objc func longPressAction(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == UIGestureRecognizer.State.began {
            self.isSelectedFood = !self.isSelectedFood
            if self.isSelectedFood {
                self.foodImageButton.backgroundColor = .signatureDustBlue
                self.selectedImageView.isHidden = false
                CartManager.shared.showCartVCAlertView()
                CartViewModel.shared.addRemoveIdx(removeIdx: self.tag, removeName: self.foodTitleLabel.text!)
            } else {
                print("isSelectedFood NOT")
            }
        }
    }
    
    @objc func tapAction(_ guesture: UITapGestureRecognizer) {
        if self.isSelectedFood {
            // TODO: 체크된 상태라면 해제
            self.foodImageButton.backgroundColor = .signatureSkyBlue
            self.selectedImageView.isHidden = true
            CartManager.shared.showCartCVTabBar()
        }
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
