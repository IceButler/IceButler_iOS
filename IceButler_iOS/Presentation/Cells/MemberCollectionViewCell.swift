//
//  MemberCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/05.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = .signatureDustBlue
        containerView.layer.cornerRadius = 12
    }

}
