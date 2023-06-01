//
//  FoodRemoveRankCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/07.
//

import UIKit
import Combine
import Kingfisher

enum KindCell: String {
    case waste = "낭비"
    case consume = "소비"
}

class FoodRemoveRankCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var wasteLabel: UILabel!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    var cancelLabels: Set<AnyCancellable> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    private func setupLayout() {
        self.layer.cornerRadius = 20
        
        self.layer.shadowColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.03)
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 30
        self.layer.shadowOpacity = 1
    }
    
    func configure(data: FoodGraphList, color: UIColor, kind: KindCell) {
        self.backgroundColor = color
        
        if let url = URL(string: data.foodCategoryImgUrl) {
            categoryImageView.kf.setImage(with: url)
        }
        
        categoryLabel.text = data.foodCategory
        
        wasteLabel.text = String(format: "%.1f", data.percentage*100) + "% | \(data.count)개가 \(kind.rawValue)되었어요."
    }

}
