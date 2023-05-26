//
//  RecipeDetailViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/22.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    private var recipeIdx: Int!
    private var recipeDatail: RecipeDetailResponseModel!
    @IBOutlet var bookmarkButton: UIBarButtonItem!
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
        fetchData()
        setup()
        setupNavigationBar()
    }
    
    private func fetchData() {
        RecipeViewModel.shared.getRecipeDetail(recipeIdx: recipeIdx) { response in
            if response != nil {
                self.recipeDatail = response
                response?.recipeFoods.forEach { ingredient in
                    self.ingredientTextList.append(ingredient.foodName + " " + ingredient.foodDetail)
                }
                self.ingredientCollectionView.reloadData()
                // TODO: 테이블뷰 reloadData()
                self.setupLayout()
            }
        }
    }
    
    private func setup() {
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self
        
        let recipeIngredientCell = UINib(nibName: "RecipeDetailIngredientCell", bundle: nil)
        ingredientCollectionView.register(recipeIngredientCell, forCellWithReuseIdentifier: "RecipeDetailIngredientCell")
    }
    
    private func setupLayout() {
        // 대표사진
        if let url = URL(string: recipeDatail.recipeImgUrl) {
            representativeImageView.kf.setImage(with: url)
            representativeImageView.contentMode = .scaleAspectFill
        }
        // 레시피명
        recipeNameLabel.text = recipeDatail.recipeName
        // 카테고리, 분량, 소요시간
        categoryLabel.text = recipeDatail.recipeCategory
        categoryView.layer.cornerRadius = categoryView.frame.height / 2
        categoryView.layer.masksToBounds = true
        amountLabel.text = "\(recipeDatail.quantity)인분"
        amountView.layer.cornerRadius = categoryView.frame.height / 2
        amountView.layer.masksToBounds = true
        timeRequiredLabel.text = "\(recipeDatail.leadTime)분"
        timeRequiredView.layer.cornerRadius = categoryView.frame.height / 2
        timeRequiredView.layer.masksToBounds = true
        // 재료
        ingredientCollectionView.collectionViewLayout = RecipeCollectionViewLeftAlignFlowLayout()
        if let flowLayout = ingredientCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        // 조리과정
        
    }
    
    func configure(recipeIdx: Int) {
        self.recipeIdx = recipeIdx
    }
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func didTapXButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension RecipeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numOfIngredient = recipeDatail?.recipeFoods.count {
            return numOfIngredient
        } else {
            return 0
        }
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
