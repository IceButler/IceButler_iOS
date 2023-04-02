//
//  CartMainTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit

protocol MainTableViewDelegate {
    func setEditMode(edit: Bool)
}

class CartMainTableViewCell: UITableViewCell {
    
    var delegate: MainTableViewDelegate?
    
    @IBOutlet weak var categoryTitleView: UIView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }      
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    private func setupCollectionView() {
        foodCollectionView.dataSource = self
        foodCollectionView.delegate = self
        foodCollectionView.register(UINib(nibName: "FoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FoodCollectionViewCell")
    }
    
    private func setupLayout() {
        selectionStyle = .none
        categoryTitleView.layer.cornerRadius = 13
        categoryTitleView.layer.borderWidth = 1.3
        categoryTitleView.layer.borderColor = UIColor.signatureBlue.cgColor
        categoryTitleLabel.textColor = .signatureBlue
        
        contentView.layer.cornerRadius = 16
    }
    
    public func setTitle(title: String) {
        self.categoryTitleLabel.text = title
    }
}

extension CartMainTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = foodCollectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as? FoodCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.foodImageButton.layer.cornerRadius = cell.foodImageButton.frame.width / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 90)
    }
    
    
}


extension CartMainTableViewCell: FoodCellDelegate {
    func setEditMode(edit: Bool) {
        if let delegate = self.delegate {
            delegate.setEditMode(edit: edit)
        }
    }
}
