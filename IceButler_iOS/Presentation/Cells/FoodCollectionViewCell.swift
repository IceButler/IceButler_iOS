//
//  FoodCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit
import Combine



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
        setupObserver()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellabels.removeAll()
    }
    
    private func setupObserver() {
        CartViewModel.shared.getRemoveIdx { removeIdx in
            print(removeIdx)
            removeIdx.forEach { idx in
                if idx == self.tag{
                    self.foodImageButton.backgroundColor = .signatureDustBlue
                    self.selectedImageView.isHidden = false
                    self.isSelectedFood = true
                    return
                }else {
                    self.isSelectedFood = false
                }
            }
        }
        
        CartViewModel.shared.isRemoveFoodIdxes { checkIdx in
            if checkIdx == false {
                CartViewModel.shared.setIsLongGesture(longGesture: false)
            }
        }
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
            CartViewModel.shared.setIsLongGesture(longGesture: true)
            setSelect()
        }
    }
    
    @objc func tapAction(_ guesture: UITapGestureRecognizer) {
        if guesture.state == UIGestureRecognizer.State.ended {
            CartViewModel.shared.getIsLongGesture { isLongGesture in
                if isLongGesture {
                    self.setSelect()
                }
            }
        }
    }
    
    func setSelect() {
        if self.isSelectedFood  {
            self.foodImageButton.backgroundColor = .signatureSkyBlue
            self.selectedImageView.isHidden = true
            CartViewModel.shared.removeRemoveIdx(removeIdx: self.tag)
        } else {
            CartViewModel.shared.addRemoveIdx(removeIdx: self.tag)
        }
    }

    @IBAction func didTapImageButton(_ sender: UIButton) {
        if self.isSelectedFood {
            CartViewModel.shared.removeRemoveIdx(removeIdx: self.tag)
            self.foodImageButton.backgroundColor = .signatureSkyBlue
            self.selectedImageView.isHidden = true
        }
    }
}
