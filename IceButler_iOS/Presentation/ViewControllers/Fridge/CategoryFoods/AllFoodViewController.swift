//
//  AllFoodViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import UIKit
import Kingfisher

class AllFoodViewController: UIViewController {
    
    @IBOutlet weak var wasteInfoView: UIView!
    
    
    @IBOutlet var discardImageView: UIImageView!
    @IBOutlet var discardLabel: UILabel!
    
    @IBOutlet weak var foodCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        FridgeViewModel.shared.getAllFoodList(fridgeIdx: 1)
        FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
    }
    
    private func setup() {
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        let foodCell = UINib(nibName: "FoodCell", bundle: nil)
        foodCollectionView.register(foodCell, forCellWithReuseIdentifier: "FoodCell")
    }
    
    private func setupLayout() {
        wasteInfoView.layer.cornerRadius = 20
        wasteInfoView.layer.shadowOffset = CGSize(width: 0, height: 4)
        wasteInfoView.layer.shadowColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        wasteInfoView.layer.shadowOpacity = 1
        
        foodCollectionView.collectionViewLayout = FoodCollectionViewLeftAlignFlowLayout()
        
        if let flowLayout = foodCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func setupObserver() {
        FridgeViewModel.shared.isChangeAllFoodList(foodListIdx:0) {
            self.foodCollectionView.reloadData()
        }
        
        FridgeViewModel.shared.fridgeDiscard { fridgeDiscard in
            if let url = URL(string: fridgeDiscard.discardFoodImgUrl ?? "") {
                self.discardImageView.kf.setImage(with: url)
            }
            self.discardLabel.text = fridgeDiscard.discardFoodCategory
        }
    }

    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        GraphViewModel.shared.fetchWasteList(fridgeIdx: 1, year: 2023, month: 5)
        
        let graphVC = UIStoryboard(name: "GraphMain", bundle: nil).instantiateViewController(withIdentifier: "GraphMainViewController") as! GraphMainViewController

        self.navigationController?.pushViewController(graphVC, animated: true)
    }
    
}

extension AllFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FridgeViewModel.shared.allFoodListCount(foodListIdx: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        FridgeViewModel.shared.allFoodListFoodDday(foodListIdx:0, index: indexPath.row, store: &cell.cancellabels) { foodDday in
            cell.setDday(foodDday: foodDday)
        }
        
        FridgeViewModel.shared.allFoodListFoodName(foodListIdx:0, index: indexPath.row, store: &cell.cancellabels) { foodName in
            cell.setFoodName(foodName: foodName)
        }
        
        FridgeViewModel.shared.allFoodListFoodImage(foodListIdx:0, index: indexPath.row, store: &cell.cancellabels) { foodImage in
            cell.setFoodImage(foodImage: foodImage)
        }
        
        cell.setFoodIdx(foodIdx: FridgeViewModel.shared.foodIdx(foodListIdx:0, index: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodIdx = FridgeViewModel.shared.foodIdx(foodListIdx:0, index: indexPath.row)
        FoodViewModel.shared.getFoodDetail(foodIdx: foodIdx)
        
        let foodDetailVC = UIStoryboard(name: "FoodDetail", bundle: nil).instantiateViewController(identifier: "FoodDetailViewController") as! FoodDetailViewController
        
        self.navigationController?.pushViewController(foodDetailVC, animated: true)
    }
    
}
