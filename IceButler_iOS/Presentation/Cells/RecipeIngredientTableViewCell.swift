//
//  RecipeIngredientTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/07.
//

import UIKit

class RecipeIngredientTableViewCell: CustomTableViewCell {

    private var indexPath: IndexPath!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        nameView.layer.cornerRadius = 10
        nameView.layer.masksToBounds = true
        amountView.layer.cornerRadius = 10
        amountView.layer.masksToBounds = true
    }
    
    @IBAction func tappedDeleteButton(_ sender: Any) {
        deleteButtonTappedDelegate?.tappedCellDeleteButton(indexPath: indexPath)
    }
    
    func configure(indexPath: IndexPath, name: String, amount: String) {
        self.indexPath = indexPath
        nameLabel.text = name
        amountLabel.text = amount
    }
}
