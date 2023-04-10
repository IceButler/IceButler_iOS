//
//  CompleteBuyingTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/07.
//

import UIKit

// MARK: 장보기 완료 팝업 내의 식품 테이블 셀
class CompleteBuyingTableViewCell: UITableViewCell {

    private var select: Bool = false
    
    @IBOutlet weak var checkImageVIew: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func setSelectedFood() {
        self.select = !self.select
        if self.select { self.checkImageVIew.image = UIImage(named: "check.fill") }
        else { self.checkImageVIew.image = UIImage(named: "check") }
    }
}
