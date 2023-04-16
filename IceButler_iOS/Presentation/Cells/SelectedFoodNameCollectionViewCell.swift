//
//  SelectedFoodNameCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/16.
//

import UIKit

protocol SelectedFoodCellDelegate {
    func didTapDeleteButton(index: Int)
}

class SelectedFoodNameCollectionViewCell: UICollectionViewCell {

    var delegate: SelectedFoodCellDelegate?
    @IBOutlet weak var selectedFoodButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapSelectedButton(_ sender: UIButton) {
        // TODO: 셀 삭제
        delegate?.didTapDeleteButton(index: self.tag)
    }
    
    public func setupLayout(title: String) {
        self.selectedFoodButton.setTitle(title, for: .normal)
        self.selectedFoodButton.layer.borderWidth = 1.6
        self.selectedFoodButton.layer.borderColor = UIColor.signatureBlue.cgColor
        self.selectedFoodButton.layer.cornerRadius = 17
    }
}
