//
//  NotificationTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    private var title: String = ""
    private var content: String = ""

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

    func configure(data: Notification) {
        switch data.pushNotificationType {
        case "냉장고":
            iconImgView.image = UIImage(named: "fridge")
            titleLabel.text = "냉장고"
        default:
            iconImgView.image = UIImage(named: "clock")
            titleLabel.text = "유통기한"
        }
        
        if let info = data.notificationInfo {
            contentLabel.text = info
        }
    }
}
