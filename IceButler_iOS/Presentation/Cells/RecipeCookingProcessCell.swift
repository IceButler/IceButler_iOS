//
//  RecipeCookingProcessCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/11.
//

import UIKit
import Kingfisher

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
    
    func configure(indexPath: IndexPath, cookingProcessList: [[Any?]]) {
        self.indexPath = indexPath
        
        let image = cookingProcessList[indexPath.row][0]
        let description = cookingProcessList[indexPath.row][1]! as! String
        if image == nil {
            addImageButton.setImage(UIImage(named: "imageAddIcon"), for: .normal)
        } else {
            if image is UIImage {
                addImageButton.setImage(image as? UIImage, for: .normal)
            } else {
                if let url = URL(string: image as! String) {
                    addImageButton.kf.setImage(with: url, for: .normal)
                    addImageButton.contentMode = .scaleAspectFill
                }
            }
        }
        cookingProcessTextView.text = description
    }
}
