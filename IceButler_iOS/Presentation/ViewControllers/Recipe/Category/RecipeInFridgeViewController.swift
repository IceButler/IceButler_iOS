//
//  RecipeInFridgeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/28.
//

import UIKit
import JGProgressHUD

class RecipeInFridgeViewController: BaseViewController {

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
        
        let fridgeType: FridgeType
        if APIManger.shared.getIsMultiFridge() { fridgeType = FridgeType.multiUse }
        else { fridgeType = FridgeType.homeUse }
        // 사용자가 냉장고를 변경했을 경우
        if APIManger.shared.getFridgeIdx() != RecipeViewModel.shared.fridgeIdxOfFridgeRecipe ||
           fridgeType != RecipeViewModel.shared.fridgeTypeOfFridgeRecipe {
            currentLoadedPageNumber = -1
            fetchData()
        }
    }
    
    private func fetchData() {
        if currentLoadedPageNumber == -1 {
            showLoading()
        }
        RecipeViewModel.shared.fridgeIdxOfFridgeRecipe = APIManger.shared.getFridgeIdx()
        if APIManger.shared.getIsMultiFridge() {
            RecipeViewModel.shared.fridgeTypeOfFridgeRecipe = .multiUse
            RecipeViewModel.shared.getFridgeRecipeList(pageNumberToLoad: currentLoadedPageNumber + 1)
        } else {
            RecipeViewModel.shared.fridgeTypeOfFridgeRecipe = .homeUse
            RecipeViewModel.shared.getFridgeRecipeList(pageNumberToLoad: currentLoadedPageNumber + 1)
        }
        currentLoadedPageNumber += 1
    }
    
    private func setup() {
        RecipeViewModel.shared.setRecipeInFridgeVC(recipeInFridgeVC: self)
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

extension RecipeInFridgeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isFirstFetch {
            if RecipeViewModel.shared.fridgeRecipeList.isEmpty {
                collectionView.setEmptyView(message: "냉장고에 식품을 추가해보세요!")
            }
            else {
                collectionView.restore()
            }
        }
        return RecipeViewModel.shared.fridgeRecipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        RecipeViewModel.shared.getFridgeRecipeCellInfo(index: indexPath.row) { recipe in
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
        recipeDetailViewController.configure(recipeIdx: selectedRecipeCell.idx!)
        recipeDetailViewController.modalPresentationStyle = .overFullScreen
        self.present(recipeDetailViewController, animated: true)
    }
    
    /* CollectionView Footer: LoadingView 설정 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading == true || RecipeViewModel.shared.fridgeRecipeIsLastPage {
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
        if !RecipeViewModel.shared.fridgeRecipeIsLastPage,
           indexPath.row == RecipeViewModel.shared.fridgeRecipeList.count - 1,
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

extension UICollectionView {
    func setEmptyView(message: String) {
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.width, height: self.bounds.height))
            return view
        }()
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .signatureBlue
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textAlignment = .center
            label.numberOfLines = 0;
            label.sizeToFit()
            return label
        }()
        emptyView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.left.equalTo(emptyView.snp.left).offset(70)
            $0.right.equalTo(emptyView.snp.right).offset(-70)
            $0.centerY.equalTo(emptyView.snp.centerY)
        }
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

class BaseViewController: UIViewController {
    lazy var hud: JGProgressHUD = {
        let loader = JGProgressHUD()
        loader.hudView.backgroundColor = .black.withAlphaComponent(0.2)
        return loader
    }()

    func showLoading() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view, animated: true)
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss(animated: false)
        }
    }
}
