//
//  SelectFridgeTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/26.
//

import UIKit

class SelectFridgeTableViewCell: UITableViewCell {

    private var isAddCell: Bool = false
    
    @IBOutlet weak var fridgeImg: UIImageView!
    @IBOutlet weak var fridgeNameLabel: UILabel!
    @IBOutlet weak var selectImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .signatureSkyBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if !isAddCell { self.selectImg.isHidden = !selected }
    }
    
    public func setFridgeModeCell(data: CommonFridgeModel?, isShareFridge: Bool) {
        if let data = data { setMyFridgeModeCell(data: data, isShareFridge: true) }
        else { setAddFridgeModeCell() }
    }
    
    public func setMyFridgeModeCell(data: CommonFridgeModel, isShareFridge: Bool) {
        fridgeNameLabel.text = data.name
        isAddCell = false
        
        if isShareFridge {
            fridgeNameLabel.textColor = UIColor(red: 41/255, green: 103/255, blue: 185/255, alpha: 1)
            fridgeImg.image = UIImage(named: "noFridge")
            
        } else {
            fridgeNameLabel.textColor = .black
            fridgeImg.image = UIImage(named: "shareFridgeIcon")
        }
    }
    
    public func setAddFridgeModeCell() {
        fridgeImg.image = UIImage(named: "addFridgeIcon")
        fridgeNameLabel.text = "냉장고 추가"
        fridgeNameLabel.textColor = UIColor(red: 100/255, green: 156/255, blue: 229/255, alpha: 1)
        selectImg.isHidden = true
        isAddCell = true
    }
}
