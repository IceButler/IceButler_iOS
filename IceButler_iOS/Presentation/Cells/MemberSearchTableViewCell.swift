//
//  MemberSearchTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/03.
//

import UIKit
import Kingfisher

class MemberSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupLayout() {
        profileImgView.layer.cornerRadius = profileImgView.frame.width/2 - 1
    }
    
    public func configure(data: FridgeUser) {
        if let urlStr = data.profileImgUrl {
            if urlStr == "https://ice-bulter-iamge-bucket.s3.ap-northeast-2.amazonaws.com/" {
                profileImgView.image = UIImage(named: "defaultProfile")
            } else {
                let url = URL(string: urlStr)
                profileImgView.kf.setImage(with: url)
            }
        } else {
            profileImgView.image = UIImage(named: "defaultProfile")
        }
        nicknameLabel.text = data.nickname
    }
}
