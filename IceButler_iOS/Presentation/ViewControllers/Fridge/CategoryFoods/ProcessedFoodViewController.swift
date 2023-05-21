//
//  ProcessedFoodViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import UIKit

class ProcessedFoodViewController: UIViewController {

    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupObserver()
    }
    
    private func setup() {
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        let foodCell = UINib(nibName: "FoodCell", bundle: nil)
        foodCollectionView.register(foodCell, forCellWithReuseIdentifier: "FoodCell")
        
        foodCollectionView.collectionViewLayout = FoodCollectionViewLeftAlignFlowLayout()
        
        if let flowLayout = foodCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func setupObserver() {
        FridgeViewModel.shared.isChangeAllFoodList(foodListIdx:9) {
            self.foodCollectionView.reloadData()
        }
    }
}

extension ProcessedFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FridgeViewModel.shared.allFoodListCount(foodListIdx: 9)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        FridgeViewModel.shared.allFoodListFoodDday(foodListIdx: 9, index: indexPath.row, store: &cell.cancellabels) { foodDday in
            cell.setDday(foodDday: foodDday)
        }
        
        FridgeViewModel.shared.allFoodListFoodName(foodListIdx: 9, index: indexPath.row, store: &cell.cancellabels) { foodName in
            cell.setFoodName(foodName: foodName)
        }
        
        FridgeViewModel.shared.allFoodListFoodImage(foodListIdx: 9, index: indexPath.row, store: &cell.cancellabels) { foodImage in
            cell.setFoodImage(foodImage: foodImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodIdx = FridgeViewModel.shared.foodIdx(foodListIdx: 9, index: indexPath.row)
        FoodViewModel.shared.getFoodDetail( foodIdx: foodIdx)
        
        let foodDetailVC = UIStoryboard(name: "FoodDetail", bundle: nil).instantiateViewController(identifier: "FoodDetailViewController") as! FoodDetailViewController
        
        self.navigationController?.pushViewController(foodDetailVC, animated: true)
    }
    
    
}
