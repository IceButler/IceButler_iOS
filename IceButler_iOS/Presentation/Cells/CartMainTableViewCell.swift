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
    @IBOutlet weak var nothingLabel: UILabel!
    
    var cartFoods: [CartFood] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
        setupCollectionView()
        setupLayout()
    }
    
    private func setup() {
        CartViewModel.shared.setCartMainTV(cartTV: self)
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
        
    public func setTitle(title: String) { self.categoryTitleLabel.text = title }
    
    func reloadCV() { foodCollectionView.reloadData() }
    
    func checkFoodsCount() {
        if cartFoods.count == 0 { nothingLabel.isHidden = false }
        else { nothingLabel.isHidden = true }
    }
}

extension CartMainTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        checkFoodsCount()
        return cartFoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = foodCollectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as? FoodCollectionViewCell else { return UICollectionViewCell() }
        
//        cell.foodImageButton.layer.cornerRadius = cell.foodImageButton.frame.width / 2
//        cell.foodTitleLabel.text = cartFoods[indexPath.row].foodName
//        cell.isSelectedFood = false
        cell.configure(name: cartFoods[indexPath.row].foodName!)
        cell.tag = cartFoods[indexPath.row].foodIdx ?? -1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 90)
    }
    
    
}

