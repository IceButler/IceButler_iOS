//
//  NotificationTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    
    @IBOutlet var iconImgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func setupLayout() {
        self.selectionStyle = .none
        containerView.layer.cornerRadius = 12
    }
}
