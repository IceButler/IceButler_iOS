//
//  FoodCategoryCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/16.
//

import UIKit

protocol FoodCategoryCellDelegate {
    func didTapCategoryButton(category: String)
}

class FoodCategoryCollectionViewCell: UICollectionViewCell {

    var delegate: FoodCategoryCellDelegate?
    private var isTapped: Bool = false
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapCategoryButton(_ sender: UIButton) {
        self.isTapped = !self.isTapped
        if self.isTapped {
            self.categoryButton.layer.borderColor = UIColor.signatureBlue.cgColor
            self.categoryButton.backgroundColor = .signatureLightBlue
            self.categoryButton.tintColor = .signatureBlue
        } else {
            self.categoryButton.layer.borderColor = UIColor.lightGray.cgColor
            self.categoryButton.backgroundColor = .white
            self.categoryButton.tintColor = .lightGray
        }
        delegate?.didTapCategoryButton(category: self.categoryButton.title(for: .normal)!)
    }
    
    public func setupLayout(title: String) {
        self.categoryLabel.text = title
        self.containerView.layer.borderWidth = 1.6
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.cornerRadius = 17
    }
    
    public func setSelectedMode(selected: Bool) {
        self.isTapped = selected
        if self.isTapped {
            self.containerView.layer.borderColor = UIColor.signatureBlue.cgColor
            self.containerView.backgroundColor = .signatureLightBlue
            self.categoryLabel.textColor = .signatureBlue
        } else {
            self.containerView.layer.borderColor = UIColor.lightGray.cgColor
            self.containerView.backgroundColor = .white
            self.categoryLabel.textColor = .lightGray
        }
    }
}
