//
//  MyRecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/20.
//

import UIKit
import JGProgressHUD

class MyRecipeViewController: BaseViewController {

    @IBOutlet var recipeCollectionView: UICollectionView!
    private var LOADING_VIEW_HEIGHT: Double = 50.0
    private var loadingView: LoadingReusableView?
    private var currentLoadedPageNumber: Int = -1
    private var isLoading: Bool = false
    private var isFirstFetch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupNavigationBar()
        setup()
        setupLayout()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func fetchData() {
        if currentLoadedPageNumber == -1 {
            showLoading()
        }
        RecipeViewModel.shared.getMyRecipeList(pageNumberToLoad: currentLoadedPageNumber + 1)
        currentLoadedPageNumber += 1
    }
    
    private func setup() {
        RecipeViewModel.shared.setMyRecipeVC(myRecipeVC: self)
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
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .navigationColor
        
        let title = UILabel()
        title.text = "마이 레시피"
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = .white
        title.textAlignment = .left
        title.sizeToFit()
        
        self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: title))
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.navigationColor
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.navigationColor
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
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

extension MyRecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isFirstFetch {
            if RecipeViewModel.shared.myRecipeList.isEmpty {
                collectionView.setEmptyView(message: "내가 만든 마이레시피가 없습니다.")
            }
            else {
                collectionView.restore()
            }
        }
        return RecipeViewModel.shared.myRecipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        RecipeViewModel.shared.getMyRecipeCellInfo(index: indexPath.row) { recipe in
            cell.setImage(imageUrl: recipe.recipeImgUrl)
            cell.setName(name: recipe.recipeName)
            cell.setCategory(category: recipe.recipeCategory)
            cell.configure(idx: recipe.recipeIdx)
            cell.bookmarkButton.isHidden = true
            cell.percentLabel.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipeDetailViewController = storyboard!.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController else { return }
        let selectedRecipeCell = collectionView.cellForItem(at: indexPath) as! RecipeCollectionViewCell
        recipeDetailViewController.configure(recipeIdx: selectedRecipeCell.idx!, isFromMyRecipe: true)
        let viewController = UINavigationController(rootViewController: recipeDetailViewController)
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
    /* CollectionView Footer: LoadingView 설정 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading == true || RecipeViewModel.shared.myRecipeIsLastPage {
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
        if !RecipeViewModel.shared.myRecipeIsLastPage,
           indexPath.row == RecipeViewModel.shared.myRecipeList.count - 1,
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
