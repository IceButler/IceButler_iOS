//
//  BookmarkRecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/01.
//

import UIKit

class BookmarkRecipeViewController: UIViewController {

    @IBOutlet weak var recipeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupNavigationBar()
        setup()
        setupLayout()
    }

    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func fetchData() {
        if APIManger.shared.getIsMultiFridge() {
            RecipeViewModel.shared.getBookmarkRecipeList(fridgeType: FridgeType.multiUse, fridgeIdx: APIManger.shared.getFridgeIdx())
        } else {
            RecipeViewModel.shared.getBookmarkRecipeList(fridgeType: FridgeType.homeUse, fridgeIdx: APIManger.shared.getFridgeIdx())
        }
    }
    
    private func setup() {
        RecipeViewModel.shared.setBookmarkRecipeVC(bookmarkRecipeVC: self)
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self

        let recipeCollectionViewCell = UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
        recipeCollectionView.register(recipeCollectionViewCell, forCellWithReuseIdentifier: "RecipeCollectionViewCell")
    }
    
    private func setupLayout() {
        recipeCollectionView.collectionViewLayout = RecipeCollectionViewFlowLayout()
    }
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .navigationColor
        
        let title = UILabel()
        title.text = "레시피 즐겨찾기"
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
    
    func updateCV() {
        recipeCollectionView.performBatchUpdates(nil)
    }
}

extension BookmarkRecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecipeViewModel.shared.bookmarkRecipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        RecipeViewModel.shared.getBookmarkRecipeCellInfo(index: indexPath.row) { recipe in
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
}
