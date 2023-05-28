//
//  RecipeDetailViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/22.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    private var recipeIdx: Int!
    private var isFromMyRecipe: Bool = false
    private var recipeDetail: RecipeDetailResponseModel!
    @IBOutlet var naviItem: UINavigationItem!
    @IBOutlet var representativeImageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var categoryView: UIView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var amountView: UIView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var timeRequiredView: UIView!
    @IBOutlet var timeRequiredLabel: UILabel!
    @IBOutlet var ingredientCollectionView: UICollectionView!
    @IBOutlet var cookingProcessTableView: UITableView!
    private var ingredientTextList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func fetchData() {
        RecipeViewModel.shared.getRecipeDetail(recipeIdx: recipeIdx) { response in
            if response != nil {
                self.recipeDetail = response
                self.ingredientTextList.removeAll()
                response?.recipeFoods.forEach { ingredient in
                    self.ingredientTextList.append(ingredient.foodName + " " + ingredient.foodDetail)
                }
                self.ingredientCollectionView.reloadData()
                self.cookingProcessTableView.reloadData()
                self.setupLayout()
            }
        }
    }
    
    private func setup() {
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self
        cookingProcessTableView.delegate = self
        cookingProcessTableView.dataSource = self
        cookingProcessTableView.rowHeight = UITableView.automaticDimension
        
        let recipeIngredientCell = UINib(nibName: "RecipeDetailIngredientCell", bundle: nil)
        ingredientCollectionView.register(recipeIngredientCell, forCellWithReuseIdentifier: "RecipeDetailIngredientCell")
        let cookingProcessCell = UINib(nibName: "RecipeDetailCookingProcessCell", bundle: nil)
        cookingProcessTableView.register(cookingProcessCell, forCellReuseIdentifier: "RecipeDetailCookingProcessCell")
    }
    
    private func setupLayout() {
        if !isFromMyRecipe {
            // 즐겨찾기
            if recipeDetail.isSubscribe {
                self.setLikeStatus(isTrue: true)
            } else {
                self.setLikeStatus(isTrue: false)
            }
        }
        // 대표사진
        if let url = URL(string: recipeDetail.recipeImgUrl) {
            representativeImageView.kf.setImage(with: url)
            representativeImageView.contentMode = .scaleAspectFill
        }
        // 레시피명
        recipeNameLabel.text = recipeDetail.recipeName
        // 카테고리, 분량, 소요시간
        categoryLabel.text = recipeDetail.recipeCategory
        categoryView.layer.cornerRadius = categoryView.frame.height / 2
        categoryView.layer.masksToBounds = true
        amountLabel.text = "\(recipeDetail.quantity)인분"
        amountView.layer.cornerRadius = categoryView.frame.height / 2
        amountView.layer.masksToBounds = true
        timeRequiredLabel.text = "\(recipeDetail.leadTime)분"
        timeRequiredView.layer.cornerRadius = categoryView.frame.height / 2
        timeRequiredView.layer.masksToBounds = true
        // 재료
        ingredientCollectionView.collectionViewLayout = RecipeCollectionViewLeftAlignFlowLayout()
        if let flowLayout = ingredientCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        // 조리과정
        cookingProcessTableView.separatorStyle = .none
    }
    
    func configure(recipeIdx: Int, isFromMyRecipe: Bool? = nil) {
        self.recipeIdx = recipeIdx
        if isFromMyRecipe != nil {
            self.isFromMyRecipe = isFromMyRecipe!
        }
    }
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        // pop up menu
        if isFromMyRecipe {
            var menuItems: [UIAction] {
                return [
                    UIAction(title: "레시피 수정", image: UIImage(named: "pencil"), handler: { _ in
                        guard let addRecipeViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddRecipeViewController") as? AddRecipeViewController else { return }
                        addRecipeViewController.configure(recipeIdx: self.recipeIdx, isEditMode: self.isFromMyRecipe, recipeDetail: self.recipeDetail)
                        self.navigationController?.pushViewController(addRecipeViewController, animated: true)
                    }),
                    UIAction(title: "레시피 삭제", image: UIImage(named: "trash"), attributes: .destructive, handler: { _ in
                        
                    })
                ]
            }
            var menu: UIMenu {
                return UIMenu(title: "", options: [], children: menuItems)
            }
            naviItem.rightBarButtonItems?.first?.menu = menu
        } else {
            var menuItems: [UIAction] {
                return [
                    UIAction(title: "신고", image: UIImage(named: "redReportIcon"), attributes: .destructive, handler: { _ in
                        
                    })
                ]
            }
            var menu: UIMenu {
                return UIMenu(title: "", options: [], children: menuItems)
            }
            naviItem.rightBarButtonItems?.first?.menu = menu
        }
    }
    
    @IBAction func didTapXButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapBookmarkButton(_ sender: Any) {
        RecipeViewModel.shared.updateBookmarkStatus(recipeIdx: recipeIdx) { bookmarkStatus in
            self.setLikeStatus(isTrue: bookmarkStatus)
        }
    }
    
    private func setLikeStatus(isTrue: Bool) {
        if naviItem.rightBarButtonItems?.count == 2 {
            naviItem.rightBarButtonItems?.removeLast()
        }
        if isTrue {
            naviItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(named: "filledStar"), style: .plain, target: self, action: #selector(didTapBookmarkButton)))
        } else {
            naviItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(named: "emptyBlackStar"), style: .plain, target: self, action: #selector(didTapBookmarkButton)))
        }
    }
}

extension RecipeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredientTextList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailIngredientCell", for: indexPath) as! RecipeDetailIngredientCell
        cell.setIngredient(ingredientText: ingredientTextList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ingredientTextList[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 10, height: 22)
    }
}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numOfCookeryStep = recipeDetail?.cookery.count {
            return numOfCookeryStep
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailCookingProcessCell", for: indexPath) as? RecipeDetailCookingProcessCell else {return UITableViewCell()}
        let cookery = recipeDetail.cookery[indexPath.row]
        cell.configure(stepNum: cookery.nextIdx + 1, description: cookery.description, cookeryImgUrl: cookery.cookeryImgUrl)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}

class IntrinsicCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        return CGSize(width: self.contentSize.width, height: height)
    }
    
    override func layoutSubviews() {
        self.invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
}
