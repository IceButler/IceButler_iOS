//
//  SelectFridgeTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/26.
//

import UIKit

class SelectFridgeTableViewCell: UITableViewCell {
    
    private var isSavedFridge: Bool = false
    
    @IBOutlet weak var fridgeImg: UIImageView!
    @IBOutlet weak var fridgeNameLabel: UILabel!
    @IBOutlet weak var selectImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .signatureSkyBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setFridgeModeCell(data: CommonFridgeModel?, isShareFridge: Bool) {
        if let data = data { setMyFridgeModeCell(data: data, isShareFridge: isShareFridge) }
    }
    
    public func setMyFridgeModeCell(data: CommonFridgeModel, isShareFridge: Bool) {
        fridgeNameLabel.text = data.name
        
        if isShareFridge {
            fridgeNameLabel.textColor = .black
            fridgeImg.image = UIImage(named: "shareFridgeIcon")
        } else {
            fridgeNameLabel.textColor = UIColor(red: 41/255, green: 103/255, blue: 185/255, alpha: 1)
            fridgeImg.image = UIImage(named: "noFridge")
        }
    }
    
    public func setIsSavedFridge(isSaved: Bool) { selectImg.isHidden = !isSaved }
}
