//
//  ChatGptCell.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/26.
//

import UIKit
import Combine

class ChatGptCell: UICollectionViewCell {

    @IBOutlet weak var gptLabel: UILabel!
    
    var cancelLabels: Set<AnyCancellable> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    private func setupLayout() {
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
        self.contentView.backgroundColor = .focusSkyBlue
    }
    
    func configure(gptText: String) {
        self.gptLabel.text = gptText
    }

}
