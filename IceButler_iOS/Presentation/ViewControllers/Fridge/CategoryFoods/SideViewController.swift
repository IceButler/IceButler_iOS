//
//  SideViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import UIKit

class SideViewController: UIViewController {

    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
}

extension SideViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        return cell
    }
    
    
}
