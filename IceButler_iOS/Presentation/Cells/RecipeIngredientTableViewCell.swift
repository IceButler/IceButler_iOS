//
//  RecipeIngredientTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/07.
//

import UIKit

class RecipeIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(name: String, amount: String) {
        nameLabel.text = name
        amountLabel.text = amount
    }
}
