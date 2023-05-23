//
//  RecipeDetailViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/22.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    private var recipeIdx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupNavigationBar()
    }
    
    private func fetchData() {
        RecipeViewModel.shared.getRecipeDetail(recipeIdx: recipeIdx) { response in
            // TODO: 컬렉션뷰, 테이블뷰 reloadData()
        }
    }
    
    private func setup() {
        
    }
    
    private func setupLayout() {
        
    }
    
    func configure(recipeIdx: Int) {
        self.recipeIdx = recipeIdx
    }
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
}
