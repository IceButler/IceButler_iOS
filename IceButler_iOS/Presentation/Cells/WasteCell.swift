//
//  WasteCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/02.
//

import UIKit

class WasteCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(category: String) {
        categoryLabel.text = category
    }

}
