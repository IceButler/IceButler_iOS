//
//  CartMainTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit

class CartMainTableViewCell: UITableViewCell {
    
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
    
    private func setupCollectionView() {
        foodCollectionView.dataSource = self
        foodCollectionView.delegate = self
        foodCollectionView.register(UINib(nibName: "FoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FoodCollectionViewCell")
    }
    
    private func setupLayout() {
        selectionStyle = .none
        categoryTitleView.layer.cornerRadius = 16
        categoryTitleView.layer.borderWidth = 1.0
        categoryTitleView.layer.borderColor = UIColor.signatureBlue.cgColor
        categoryTitleLabel.textColor = .signatureBlue
        
        self.layer.cornerRadius = 22
        self.layer.shadowColor = UIColor.systemGray.cgColor
//        cell.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        self.contentView.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowOpacity = 0.7
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
        cell.foodImageView.layer.cornerRadius = cell.foodImageView.frame.width / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 90)
    }
    
    
}
