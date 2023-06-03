//
//  RecipeSearchViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/28.
//

import UIKit

class RecipeSearchViewController: BaseViewController {
    
    @IBOutlet var recipeCollectionView: UICollectionView!
    private var LOADING_VIEW_HEIGHT: Double = 50.0
    private var loadingView: LoadingReusableView?
    private var currentLoadedPageNumber: Int = -1
    private var isLoading: Bool = false
    private var isFirstFetch: Bool = true
    
    private var searchBar: UISearchBar! = nil
    private var selectedCategory: RecipeSearchUICategory!
    private var keyword: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        setupNavigationBar()
        initSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // 상세 화면에서 레시피 즐겨찾기 했을 경우
        if let cellIndexPath = RecipeViewModel.shared.cellIndexPathToRelaod {
            var indexPaths: [IndexPath] = []
            indexPaths.append(cellIndexPath)
            recipeCollectionView.reloadItems(at: indexPaths)
            RecipeViewModel.shared.cellIndexPathToRelaod = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSearchBarRightView()
    }
    
    private func fetchData() {
        if let keyword = keyword {
            if currentLoadedPageNumber == -1 {
                showLoading()
            }
            let fridgeIdx = APIManger.shared.getFridgeIdx()
            if APIManger.shared.getIsMultiFridge() {
                RecipeViewModel.shared.getRecipeSearchList(fridgeIdx: fridgeIdx, fridgeType: FridgeType.multiUse, category: selectedCategory, keyword: keyword, pageNumberToLoad: currentLoadedPageNumber + 1)
            } else {
                RecipeViewModel.shared.getRecipeSearchList(fridgeIdx: fridgeIdx, fridgeType: FridgeType.homeUse, category: selectedCategory, keyword: keyword, pageNumberToLoad: currentLoadedPageNumber + 1)
            }
            currentLoadedPageNumber += 1
        }
    }
    
    private func setup() {
        RecipeViewModel.shared.setRecipeSearchVC(recipeSearchVC: self)
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
        tabBarController?.tabBar.isHidden = true
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: createCategorySelectionButton(category: RecipeSearchUICategory.recipeName)))
        
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
    }
    
    private func createCategorySelectionButton(category: RecipeSearchUICategory) -> UIButton {
        selectedCategory = category
        let keywordSelectionBtn = UIButton(type: .custom)
        keywordSelectionBtn.frame = CGRect(x: 0, y: 0, width: 90, height: 36)
        keywordSelectionBtn.setTitle(category.rawValue, for: .normal)
        keywordSelectionBtn.setTitleColor(.signatureBlue, for: .normal)
        keywordSelectionBtn.titleLabel?.font = .systemFont(ofSize: 16)
        keywordSelectionBtn.backgroundColor = .white.withAlphaComponent(0.9)
        keywordSelectionBtn.layer.cornerRadius = keywordSelectionBtn.frame.height / 2
        keywordSelectionBtn.layer.masksToBounds = true
        keywordSelectionBtn.layer.applyShadow(color: .black, alpha: 0.2, x: 0, y: 4, blur: 10, spread: 0)
        keywordSelectionBtn.addTarget(self, action: #selector(didTapCategorySelectionBtn), for: .touchUpInside)
        return keywordSelectionBtn
    }
    
    private func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.layoutIfNeeded()
        searchBar.layoutSubviews()
        searchBar.placeholder = ""
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        searchBar.searchTextField.layer.cornerRadius = searchBar.searchTextField.frame.height / 2
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.delegate = self
        searchBar.searchTextField.returnKeyType = .search
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        // 왼쪽 기본 돋보기 이미지 빼기
        searchBar.searchTextField.leftViewMode = .never
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        navigationItem.titleView = searchBar
    }
    
    private func setSearchBarRightView() {
        // 오른쪽에 검색 버튼(돋보기) 넣기
        searchBar.searchTextField.clearButtonMode = .never
        let searchBtn = UIButton(type: .custom)
        searchBtn.setImage(UIImage(named: "searchWhiteIcon"), for: .normal)
        searchBar.searchTextField.rightView = searchBtn
        searchBar.searchTextField.rightViewMode = .always
        // 검색 버튼 탭 제스처 등록
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchButton(_:)))
        searchBar.searchTextField.rightView!.addGestureRecognizer(tapGesture)
        searchBar.searchTextField.rightView!.isUserInteractionEnabled = true
    }
    
    @objc func didTapCategorySelectionBtn(sender: UIButton!) {
        let actionSheet = UIAlertController(title: "검색 카테고리 선택", message: nil, preferredStyle: .actionSheet)
        [
            UIAlertAction(title: RecipeSearchUICategory.recipeName.rawValue, style: .default, handler: { [self] _ in
              navigationItem.leftBarButtonItems?.removeLast()
              navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: createCategorySelectionButton(category: RecipeSearchUICategory.recipeName)))
          }),
            UIAlertAction(title: RecipeSearchUICategory.ingredientName.rawValue, style: .default, handler: { [self] _ in
              navigationItem.leftBarButtonItems?.removeLast()
              navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: createCategorySelectionButton(category: RecipeSearchUICategory.ingredientName)))
          }),
          UIAlertAction(title: "취소", style: .cancel)
        ].forEach{ actionSheet.addAction($0) }

        self.present(actionSheet, animated: true)
    }
    
    @objc func didTapSearchButton(_ gesture: UITapGestureRecognizer) {
        if !(searchBar.searchTextField.text?.isEmpty ?? true) {
            view.endEditing(true)
            currentLoadedPageNumber = -1
            keyword = searchBar.searchTextField.text
            fetchData()
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
        
    func updateCV(indexArray: [IndexPath]) {
        if currentLoadedPageNumber == 0 {
            recipeCollectionView.reloadData()
        } else {
            recipeCollectionView.insertItems(at: indexArray)
        }
        hideLoading()
    }
}

extension RecipeSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.text?.isEmpty ?? true) {
            view.endEditing(true)
            currentLoadedPageNumber = -1
            keyword = textField.text
            fetchData()
            return true
        }
        return false
    }
}

extension RecipeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isFirstFetch {
            if RecipeViewModel.shared.searchRecipeList.isEmpty {
                collectionView.setEmptyView(message: "검색 결과가 없습니다.")
            }
            else {
                collectionView.restore()
            }
        }
        return RecipeViewModel.shared.searchRecipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        RecipeViewModel.shared.getSearchRecipeCellInfo(index: indexPath.row) { recipe in
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
        recipeDetailViewController.configure(recipeIdx: selectedRecipeCell.idx!, indexPath: indexPath, recipeType: .search)
        recipeDetailViewController.modalPresentationStyle = .fullScreen
        self.present(recipeDetailViewController, animated: true)
    }
    
    /* CollectionView Footer: LoadingView 설정 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading == true || RecipeViewModel.shared.searchRecipeIsLastPage {
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
        if !RecipeViewModel.shared.searchRecipeIsLastPage,
           indexPath.row == RecipeViewModel.shared.searchRecipeList.count - 1,
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
