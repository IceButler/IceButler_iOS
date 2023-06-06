//
//  FoodOwnerCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/08.
//

import UIKit
import Combine
import Kingfisher

class FoodOwnerCell: UITableViewCell {
    
    @IBOutlet weak var ownerSelectImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    private var focus: Bool = false
    
    var cancellabels: Set<AnyCancellable> = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout(focus: focus)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellabels.removeAll()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupLayout(focus: Bool) {
        ownerSelectImageView.layer.cornerRadius = ownerSelectImageView.frame.width / 2
        contentView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
    }
    
    func configure(name: String, isSelect: Bool) {
        ownerNameLabel.text = name
        
        
        
        
        
        if isSelect {
            ownerNameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 700))
        }else {
            ownerNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        
    }
    
    func setImage(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            ownerSelectImageView.kf.setImage(with: url)
        }
    }
    
    func isFocus(focus: Bool) {
        if focus {
            contentView.backgroundColor = .focusTableViewSkyBlue
            ownerSelectImageView.backgroundColor = .signatureDustBlue
        }
    }
    
    
}
