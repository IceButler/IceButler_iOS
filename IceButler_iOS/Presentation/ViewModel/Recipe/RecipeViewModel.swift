//
//  RecipeViewModel.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/29.
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    static let shared = RecipeViewModel()
    private let recipeService = RecipeService()
    
    @Published var fridgeRecipeList: [Recipe] = []
    @Published var popularRecipeList: [Recipe] = []
    
    private var recipeInFridgeVC: RecipeInFridgeViewController? = nil
    private var popularRecipeVC: PopularRecipeViewController? = nil
    
    func setRecipeInFridgeVC(recipeInFridgeVC: RecipeInFridgeViewController) {
        self.recipeInFridgeVC = recipeInFridgeVC
    }
    func setPopularRecipeVC(popularRecipeVC: PopularRecipeViewController) {
        self.popularRecipeVC = popularRecipeVC
    }
    
    func getFridgeRecipeList(fridgeType: FridgeType, fridgeIdx: Int) {
        recipeService.getFridgeRecipes(fridgeType: fridgeType, fridgeIdx: fridgeIdx) { response in
            self.fridgeRecipeList.removeAll()
            response?.recipeMainResList.forEach { recipe in
                self.fridgeRecipeList.append(recipe)
                self.recipeInFridgeVC?.reloadCV()
            }
        }
    }
    
    func getPopularRecipeList(fridgeType: FridgeType, fridgeIdx: Int) {
        recipeService.getPopularRecipes(fridgeType: fridgeType, fridgeIdx: fridgeIdx) { response in
            self.popularRecipeList.removeAll()
            response?.recipeMainResList.forEach { recipe in
                self.popularRecipeList.append(recipe)
                self.popularRecipeVC?.reloadCV()
            }
        }
    }
    
    func getRecipeCellInfo(index: Int, completion: @escaping (Recipe) -> Void) {
        completion(fridgeRecipeList[index])
    }
}
