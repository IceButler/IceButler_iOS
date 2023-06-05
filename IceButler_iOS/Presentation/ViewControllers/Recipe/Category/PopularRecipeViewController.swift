//
//  PopularRecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/28.
//

import UIKit
import JGProgressHUD

class PopularRecipeViewController: BaseViewController {

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
        
        if !isFirstFetch {
            let fridgeType: FridgeType
            if APIManger.shared.getIsMultiFridge() { fridgeType = FridgeType.multiUse }
            else { fridgeType = FridgeType.homeUse }
            // 사용자가 냉장고를 변경했을 경우
            if APIManger.shared.getFridgeIdx() != RecipeViewModel.shared.fridgeIdxOfPopularRecipe ||
                fridgeType != RecipeViewModel.shared.fridgeTypeOfPopularRecipe {
                currentLoadedPageNumber = -1
                fetchData()
            }
            // 사용자가 음식 추가/수정/삭제 or 레시피 추가/수정했을 경우
            else if RecipeViewModel.shared.needToUpdatePopularRecipe {
                currentLoadedPageNumber = -1
                fetchData()
                RecipeViewModel.shared.needToUpdateRecipe(inPopular: false)
            }
            // 상세 화면에서 레시피 즐겨찾기 했을 경우
            else if let cellIndexPath = RecipeViewModel.shared.cellIndexPathToRelaod {
                var indexPaths: [IndexPath] = []
                indexPaths.append(cellIndexPath)
                recipeCollectionView.reloadItems(at: indexPaths)
                RecipeViewModel.shared.cellIndexPathToRelaod = nil
            }
        }
    }
    
    private func fetchData() {
        // 냉장고 미선택인 경우 아예 레시피 조회 불가능
        if APIManger.shared.getFridgeIdx() == -1 {
            recipeCollectionView.setEmptyView(message: "냉장고를 선택해주세요.")
            return
        }
        
        if currentLoadedPageNumber == -1 {
            showLoading()
        }
        RecipeViewModel.shared.fridgeIdxOfPopularRecipe = APIManger.shared.getFridgeIdx()
        if APIManger.shared.getIsMultiFridge() {
            RecipeViewModel.shared.fridgeTypeOfPopularRecipe = .multiUse
            RecipeViewModel.shared.getPopularRecipeList(pageNumberToLoad: currentLoadedPageNumber + 1)
        } else {
            RecipeViewModel.shared.fridgeTypeOfPopularRecipe = .homeUse
            RecipeViewModel.shared.getPopularRecipeList(pageNumberToLoad: currentLoadedPageNumber + 1)
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
        loadingView?.activityIndicatorView.hidesWhenStopped = true
    }
    
    func updateCV(indexArray: [IndexPath]) {
        if currentLoadedPageNumber == 0 {
            recipeCollectionView.reloadData()
        } else {
            recipeCollectionView.insertItems(at: indexArray)
        }
        hideLoading()
    }
    
    func showServerErrorAlert(description: String? = nil) {
        hideLoading()
        currentLoadedPageNumber = -1
        recipeCollectionView.setEmptyView(message: "냉장고에 식품을 추가해보세요!")
        if let description = description {
            let alert = UIAlertController(title: "서버 오류 발생", message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "서버 오류 발생", message: "데이터를 불러올 수 없습니다. 잠시 후에 다시 시도해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
}

extension PopularRecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isFirstFetch {
            if RecipeViewModel.shared.popularRecipeList.isEmpty {
                collectionView.setEmptyView(message: "인기 레시피가 없습니다.")
            }
            else {
                collectionView.restore()
            }
        }
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
        guard let recipeDetailViewController = storyboard!.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController else { return }
        let selectedRecipeCell = collectionView.cellForItem(at: indexPath) as! RecipeCollectionViewCell
        recipeDetailViewController.configure(recipeIdx: selectedRecipeCell.idx!, indexPath: indexPath, recipeType: .popular)
        recipeDetailViewController.modalPresentationStyle = .fullScreen
        self.present(recipeDetailViewController, animated: true)
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
