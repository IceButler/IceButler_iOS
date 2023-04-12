//
//  MypageMenuTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/12.
//

import UIKit

class MypageMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImgView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
