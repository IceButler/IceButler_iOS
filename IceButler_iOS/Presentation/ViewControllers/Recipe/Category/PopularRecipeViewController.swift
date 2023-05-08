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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        if APIManger.shared.getIsMultiFridge() {
            RecipeViewModel.shared.getPopularRecipeList(fridgeType: FridgeType.multiUse, fridgeIdx: APIManger.shared.getFridgeIdx())
        } else {
            RecipeViewModel.shared.getPopularRecipeList(fridgeType: FridgeType.homeUse, fridgeIdx: APIManger.shared.getFridgeIdx())
        }
    }
    
    private func setup() {
        RecipeViewModel.shared.setPopularRecipeVC(popularRecipeVC: self)
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self

        let recipeCollectionViewCell = UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
        recipeCollectionView.register(recipeCollectionViewCell, forCellWithReuseIdentifier: "RecipeCollectionViewCell")
    }
    
    private func setupLayout() {
        recipeCollectionView.collectionViewLayout = RecipeCollectionViewFlowLayout()
    }
    
    func reloadCV() {
        recipeCollectionView.reloadData()
    }
}

extension PopularRecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecipeViewModel.shared.popularRecipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        RecipeViewModel.shared.getPopularRecipeCellInfo(index: indexPath.row) { recipe in
            cell.setImage(imageUrl: recipe!.recipeImgUrl)
            cell.setName(name: recipe!.recipeName)
            cell.setCategory(category: recipe!.recipeCategory)
            cell.setPercent(percent: recipe!.percentageOfFood)
            cell.setLikeStatus(status: recipe!.recipeLikeStatus)
            cell.configure(idx: recipe!.recipeIdx)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
