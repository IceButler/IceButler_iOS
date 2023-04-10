//
//  FoodAddSelectCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/05.
//

import UIKit

class FoodAddSelectCell: UITableViewCell {
    
    
    @IBOutlet weak var selectIconImageView: UIImageView!
    @IBOutlet weak var selectTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(image: UIImage, title: String) {
        selectIconImageView.image = image
        selectTitleLabel.text = title
    }
    
}
