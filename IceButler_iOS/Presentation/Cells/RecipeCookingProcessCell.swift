//
//  RecipeCookingProcessCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/11.
//

import UIKit

class RecipeCookingProcessCell: UITableViewCell {

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var cookingProcessTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        addImageButton.layer.cornerRadius = 10
        addImageButton.layer.masksToBounds = true
        cookingProcessTextView.layer.cornerRadius = 10
        cookingProcessTextView.layer.masksToBounds = true
        cookingProcessTextView.textContainerInset = UIEdgeInsets(top: 12, left: 13, bottom: 12, right: 13);
    }
    
    func configure(image: String?, description: String) {
        cookingProcessTextView.text = description
    }
}
