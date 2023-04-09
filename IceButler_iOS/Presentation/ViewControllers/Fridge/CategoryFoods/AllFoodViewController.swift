//
//  AllFoodViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import UIKit

class AllFoodViewController: UIViewController {
    
    @IBOutlet weak var wasteInfoView: UIView!
    
    @IBOutlet weak var foodCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
    
    private func setup() {
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        let foodCell = UINib(nibName: "FoodCollectionViewCell", bundle: nil)
        foodCollectionView.register(foodCell, forCellWithReuseIdentifier: "FoodCollectionViewCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToWasteVC))
        wasteInfoView.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        wasteInfoView.layer.cornerRadius = 20
        wasteInfoView.layer.shadowOffset = CGSize(width: 0, height: 4)
        wasteInfoView.layer.shadowColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        wasteInfoView.layer.shadowOpacity = 1
    }
    
    @objc private func moveToWasteVC() {
        
    }
}

extension AllFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as! FoodCollectionViewCell
        cell.foodImageButton.layer.cornerRadius = cell.foodImageButton.frame.width / 2
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 90)
    }
    
}
