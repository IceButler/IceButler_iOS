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
    
    func setRecipeInFridgeVC(recipeInFridgeVC: RecipeInFridgeViewController) {
        self.recipeInFridgeVC = recipeInFridgeVC
    }
    
    // 가정용, 공용은 같이 하고
    // 냉장고 속 레시피랑 인기레시피 함수 나눠서 하자
    func getFridgeRecipeList(fridgeType: FridgeType, fridgeIdx: Int) {
        recipeService.getFridgeRecipes(fridgeType: fridgeType, fridgeIdx: fridgeIdx) { response in
            self.fridgeRecipeList.removeAll()
            response?.recipeMainResList.forEach { recipe in
                self.fridgeRecipeList.append(recipe)
                self.recipeInFridgeVC?.recipeCollectionView.reloadData()
            }
        }
    }
    
    func getRecipeCellInfo(index: Int, completion: @escaping (Recipe) -> Void) {
        completion(fridgeRecipeList[index])
    }
}
