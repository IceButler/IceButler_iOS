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
//    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupLayout() {
        crownImg.isHidden = true
        imgView.layer.borderWidth = 0
        nickname.font = .systemFont(ofSize: 10, weight: .regular)
//        imgView.tintColor = UIColor(red: 194/255, green: 210/255, blue: 227/255, alpha: 1)
//        imgView.backgroundColor = UIColor(red: 41/255, green: 90/255, blue: 153/255, alpha: 1)
        imgView.image = UIImage(named: "person.fill")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = imgView.frame.width / 2 - 2
    }
    
    public func setupMainMemberProfile() {
        crownImg.isHidden = false
        imgView.layer.cornerRadius = imgView.frame.width / 2 - 2
        imgView.layer.borderColor = UIColor.signatureLightBlue.cgColor
        imgView.layer.borderWidth = 3.0
        nickname.font = .systemFont(ofSize: 10, weight: .heavy)
    }

    public func configure(data: FridgeUser) {
        nickname.text = data.nickname
        if let imgUrlStr = data.profileImgUrl {
            let url = URL(string: imgUrlStr)
            imgView.kf.setImage(with: url)
        }
        else { imgView.image = UIImage(named: "person.fill") }
        if data.role == "OWNER" { setupMainMemberProfile()  }
        else { crownImg.isHidden = true }
    }
}
