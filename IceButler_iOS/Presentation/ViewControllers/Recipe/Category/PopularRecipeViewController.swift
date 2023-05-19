//
//  PopularRecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/28.
//

import UIKit

class PopularRecipeViewController: UIViewController {

    @IBOutlet weak var recipeCollectionView: UICollectionView!
    private var LOADING_VIEW_HEIGHT: Double = 50.0
    private var loadingView: LoadingReusableView?
    private var currentLoadedPageNumber: Int = -1
    private var isLoading: Bool = false
    private var isFirstFetch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setup()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 사용자가 냉장고를 변경했으면 (fridgeIdx가 변경됐으면) 다시 fetchData() 해야함
        // isFirstFetch, currentLoadedPageNumber도 다시 초기화
    }
    
    private func fetchData() {
        if APIManger.shared.getIsMultiFridge() {
            RecipeViewModel.shared.getPopularRecipeList(fridgeType: FridgeType.multiUse, fridgeIdx: APIManger.shared.getFridgeIdx(), pageNumberToLoad: currentLoadedPageNumber + 1)
        } else {
            RecipeViewModel.shared.getPopularRecipeList(fridgeType: FridgeType.homeUse, fridgeIdx: APIManger.shared.getFridgeIdx(), pageNumberToLoad: currentLoadedPageNumber + 1)
        }
        currentLoadedPageNumber += 1
    }
    
    private func setup() {
        RecipeViewModel.shared.setPopularRecipeVC(popularRecipeVC: self)
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self

        let recipeCollectionViewCell = UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
        recipeCollectionView.register(recipeCollectionViewCell, forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        let loadingReusableCell = UINib(nibName: "LoadingReusableView", bundle: nil)
        recipeCollectionView.register(loadingReusableCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingView")
    }
    
    private func setupLayout() {
        recipeCollectionView.collectionViewLayout = RecipeCollectionViewFlowLayout()
    }
    
    func updateCV(indexArray: [IndexPath]) {
        if currentLoadedPageNumber == 0 {
            recipeCollectionView.reloadData()
        } else {
            recipeCollectionView.insertItems(at: indexArray)
        }
    }
}

extension PopularRecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecipeViewModel.shared.popularRecipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        RecipeViewModel.shared.getPopularRecipeCellInfo(index: indexPath.row) { recipe in
            cell.setImage(imageUrl: recipe.recipeImgUrl)
            cell.setName(name: recipe.recipeName)
            cell.setCategory(category: recipe.recipeCategory)
            cell.setPercent(percent: recipe.percentageOfFood)
            cell.setLikeStatus(status: recipe.recipeLikeStatus)
            cell.configure(idx: recipe.recipeIdx)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    /* CollectionView Footer: LoadingView 설정 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading == true || RecipeViewModel.shared.popularRecipeIsLastPage {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.frame.size.width, height: LOADING_VIEW_HEIGHT)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingView", for: indexPath) as! LoadingReusableView
            loadingView = footerView
            loadingView?.backgroundColor = UIColor.clear
            loadingView?.isHidden = false
            if isFirstFetch {
                loadingView?.isHidden = true
                isFirstFetch = false
            }

            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if self.isLoading {
                self.loadingView?.activityIndicatorView.startAnimating()
            } else {
                self.loadingView?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicatorView.stopAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !RecipeViewModel.shared.popularRecipeIsLastPage,
           indexPath.row == RecipeViewModel.shared.popularRecipeList.count - 1,
           self.isLoading == false {
            loadMoreData()
        }
    }

    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                DispatchQueue.main.async {
                    self.fetchData()
                    self.isLoading = false
                }
            }
        }
    }
}
