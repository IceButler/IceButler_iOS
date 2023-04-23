//
//  RefriMemberCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/23.
//

import UIKit

class RefriMemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var crownImg: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupLayout() {
        imgView.layer.cornerRadius = imgView.frame.width / 2
    }
    
    public func setupMainMemberProfile(isMain: Bool) {
        if isMain { crownImg.isHidden = false }
        else { crownImg.isHidden = true }
    }

}
