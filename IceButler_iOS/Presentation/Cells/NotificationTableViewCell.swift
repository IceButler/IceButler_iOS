//
//  NotificationTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/23.
//

import UIKit

enum NotificationType: String {
    case frdige = "냉장고"
    case alarm = "유통기한"
}

class NotificationTableViewCell: UITableViewCell {
    
    private var type: NotificationType?
    private var title: String = ""
    private var content: String = ""

    @IBOutlet var containerView: UIView!
    
    @IBOutlet var iconImgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        setupData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func setupLayout() {
        self.selectionStyle = .none
        containerView.layer.cornerRadius = 12
    }
    
    private func setupData() {
        titleLabel.text = type?.rawValue
        contentLabel.text = content
        
        switch type{
        case .frdige: iconImgView.image = UIImage(named: "fridge")
        case .alarm: iconImgView.image = UIImage(named: "clock")
        default: return
        }
    }
    
    func configure(data: Notification) {
        switch data.pushNotificationType {
        case "냉장고": type = NotificationType.frdige
        case "유통기한": type = NotificationType.alarm
        default: return
        }
        
        if let info = data.notificationInfo { content = info }
    }
}
