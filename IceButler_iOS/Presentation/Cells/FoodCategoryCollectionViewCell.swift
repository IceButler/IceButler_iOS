//
//  FoodCategoryCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/16.
//

import UIKit

class FoodCategoryCollectionViewCell: UICollectionViewCell {

    private var isTapped: Bool = false
    
    @IBOutlet weak var categoryButton: UIButton!
    
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
    }
    
    public func setupLayout(title: String) {
        self.categoryButton.setTitle(title, for: .normal)
        self.categoryButton.layer.borderWidth = 1.6
        self.categoryButton.layer.borderColor = UIColor.lightGray.cgColor
        self.categoryButton.layer.cornerRadius = 17
    }
}
