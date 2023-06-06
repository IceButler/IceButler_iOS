//
//  FoodCategoryCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/07.
//

import UIKit

class FoodCategoryCell: UITableViewCell {

    @IBOutlet weak var foodCategoryTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupLayout() {
        self.contentView.backgroundColor = .focusTableViewSkyBlue
    }
    
    
    func configure(categoryTitle: String) {
        foodCategoryTitleLabel.text = categoryTitle
    }
}
