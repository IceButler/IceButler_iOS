//
//  FoodCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit

protocol FoodCellDelegate {
    func setEditMode(edit: Bool)
    func deleteFoodsAction(index: Int, row: Int)
}

class FoodCollectionViewCell: UICollectionViewCell {

    var isSelectedFood: Bool = false
    var delegate: FoodCellDelegate?
    
    @IBOutlet weak var foodImageButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureHandler()
        setupLayout()
    }
    
    private func setupGestureHandler() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        self.foodImageButton.addGestureRecognizer(longPressGesture)
    }
    
    private func setupLayout() {
        self.foodImageButton.backgroundColor = UIColor.signatureSkyBlue
        self.foodImageButton.layer.cornerRadius = self.foodImageButton.frame.width / 2
    }
    
    @objc func longPressAction(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == UIGestureRecognizer.State.began {
            self.isSelectedFood = !self.isSelectedFood
//            && CartManager.shared.status == .processing
            if self.isSelectedFood  {
                self.foodImageButton.backgroundColor = .signatureDustBlue
                self.selectedImageView.isHidden = false
                CartViewModel.shared.addRemoveIdx(removeIdx: self.tag)
                
            } else {
                CartViewModel.shared.removeRemoveIdx(removeIdx: self.tag)
                self.foodImageButton.backgroundColor = .signatureSkyBlue
                self.selectedImageView.isHidden = true
            }
        }
    }

    @IBAction func didTapImageButton(_ sender: UIButton) {
        if self.isSelectedFood {
            self.foodImageButton.backgroundColor = .signatureSkyBlue
            self.selectedImageView.isHidden = true
            self.delegate?.setEditMode(edit: false)
        }
    }
}

extension FoodCollectionViewCell: AlertDelegate {
    func deleteFoodsAction() {
        print("tag : \(self.tag)")
//        print("FoodCollectionViewCell :: deleteFoodsAction called")
//        delegate?.deleteFoodsAction(index: self.tag, row: 0)    //  TODO:
//        CartManager.shared.status = .done
//        delegate?.setEditMode(edit: false)
    }
}
