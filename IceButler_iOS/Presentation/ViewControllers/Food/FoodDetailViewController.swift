//
//  FoodDetailViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import UIKit

class FoodDetailViewController: UIViewController {

    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDetailLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var foodShelfLifeLabel: UILabel!
    @IBOutlet weak var foodDdayLabel: UILabel!
    @IBOutlet weak var foodOwnerLabel: UILabel!
    @IBOutlet weak var foodMemoLabel: UILabel!
    @IBOutlet weak var foodImageCollectionView: UICollectionView!
    @IBOutlet weak var completeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupObserver()
    }
    
    private func setup() {
        foodImageCollectionView.dataSource = self
        foodImageCollectionView.delegate = self
        
        let foodImageCell = UINib(nibName: "FoodAddImageCell", bundle: nil)
        foodImageCollectionView.register(foodImageCell, forCellWithReuseIdentifier: "FoodAddImageCell")
    }
    
    private func setupLayout() {
        [foodNameLabel, foodDetailLabel, foodCategoryLabel, foodShelfLifeLabel, foodDdayLabel, foodOwnerLabel, foodMemoLabel].forEach { label in
            label?.backgroundColor = .focusTableViewSkyBlue
            label?.layer.cornerRadius = 10
        }
        
        foodMemoLabel.lineBreakMode = .byCharWrapping
        foodMemoLabel.numberOfLines = 4
    }
    
    private func setupObserver() {
        FoodViewModel.shared.food { food in
            self.foodNameLabel.text = food.foodName
            self.foodDetailLabel.text = food.foodDetailName
            self.foodCategoryLabel.text = food.foodCategory
            self.foodShelfLifeLabel.text = food.shelfLife
            self.foodDdayLabel.text = food.day
            self.foodOwnerLabel.text = food.owner
            self.foodMemoLabel.text = food.memo
        }
    }
    
    
    
}

extension FoodDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodAddImageCell", for: indexPath) as! FoodAddImageCell
        
        cell.hiddenFoodImageAddIcon()
        
        return cell
    }
    
    
}
