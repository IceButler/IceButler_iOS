//
//  PopularRecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/28.
//

import UIKit

class PopularRecipeViewController: UIViewController {

    @IBOutlet weak var recipeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }

    private func setup() {
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self

        let recipeCollectionViewCell = UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
        recipeCollectionView.register(recipeCollectionViewCell, forCellWithReuseIdentifier: "RecipeCollectionViewCell")

        recipeCollectionView.collectionViewLayout = RecipeCollectionViewFlowLayout()
    }
    
    private func setupLayout() {
        recipeCollectionView.layer.backgroundColor = UIColor.recipeBackgroudColor.cgColor
    }
    
    private func setupObserver() {
    }
}

extension PopularRecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recipeCollectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        cell.recipeImageView.image = UIImage(named: "dbt")
        cell.recipeImageView.contentMode = .scaleAspectFill
        cell.recipeNameLabel.text = "닭볶음탕"

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
