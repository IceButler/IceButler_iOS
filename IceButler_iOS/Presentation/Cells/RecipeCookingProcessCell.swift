//
//  RecipeCookingProcessCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/11.
//

import UIKit

class RecipeCookingProcessCell: CustomTableViewCell {

    weak var addImageButtonTappedDelegate: AddImageButtonTappedDelegate?
    private var indexPath: IndexPath!
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
        addImageButton.imageView?.contentMode = .scaleAspectFill
        cookingProcessTextView.layer.cornerRadius = 10
        cookingProcessTextView.layer.masksToBounds = true
        cookingProcessTextView.textContainerInset = UIEdgeInsets(top: 12, left: 13, bottom: 12, right: 13);
    }
    
    @IBAction func tappedAddImageButton(_ sender: Any) {
        addImageButtonTappedDelegate?.tappedCellAddImageButton(indexPath: indexPath)
    }
    
    @IBAction func tappedDeleteButton(_ sender: Any) {
        deleteButtonTappedDelegate?.tappedCellDeleteButton(indexPath: indexPath)
    }
    
    func configure(indexPath: IndexPath, image: UIImage?, description: String) {
        self.indexPath = indexPath
        addImageButton.setImage(image, for: .normal)
        cookingProcessTextView.text = description
    }
}
