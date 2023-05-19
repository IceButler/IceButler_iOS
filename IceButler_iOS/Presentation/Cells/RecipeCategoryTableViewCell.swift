//
//  RecipeCategoryTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/05.
//

import UIKit

class RecipeCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(categoryTitle: String) {
        categoryTitleLabel.text = categoryTitle
    }
    
}
