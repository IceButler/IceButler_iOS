//
//  RefriMemberCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/23.
//

import UIKit
import Kingfisher

class RefriMemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var crownImg: UIImageView!
    
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupLayout() {
        crownImg.isHidden = true
        profileImgView.layer.borderWidth = 0
        nickname.font = .systemFont(ofSize: 10, weight: .regular)
        profileImgView.layer.cornerRadius = profileImgView.frame.width / 2 - 2
    }
    
    public func setupMainMemberProfile() {
        crownImg.isHidden = false
        profileImgView.layer.cornerRadius = profileImgView.frame.width / 2 - 2
        profileImgView.layer.borderColor = UIColor.signatureLightBlue.cgColor
        profileImgView.layer.borderWidth = 3.0
        nickname.font = .systemFont(ofSize: 10, weight: .heavy)
    }

    public func configure(data: FridgeUser) {
        nickname.text = data.nickname
        if let imgUrlStr = data.profileImgUrl {
            let url = URL(string: imgUrlStr)
            profileImgView.kf.setImage(with: url)
        }
        else { profileImgView.image = UIImage(named: "defaultProfile") }
        if data.role == "OWNER" { setupMainMemberProfile()  }
        else { crownImg.isHidden = true }
    }
}
