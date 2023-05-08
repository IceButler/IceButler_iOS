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
    @Published var bookmarkRecipeList: [Recipe] = []
    
    private var recentlyUpdatedList: RecipeListType!
    private var recipeInFridgeVC: RecipeInFridgeViewController? = nil
    private var popularRecipeVC: PopularRecipeViewController? = nil
    private var bookmarkRecipeVC: BookmarkRecipeViewController? = nil
    
    func getRecentlyUpdatedList() -> RecipeListType { return recentlyUpdatedList }
    func setRecipeInFridgeVC(recipeInFridgeVC: RecipeInFridgeViewController) {
        self.recipeInFridgeVC = recipeInFridgeVC
    }
    func setPopularRecipeVC(popularRecipeVC: PopularRecipeViewController) {
        self.popularRecipeVC = popularRecipeVC
    }
    func setBookmarkRecipeVC(bookmarkRecipeVC: BookmarkRecipeViewController) {
        self.bookmarkRecipeVC = bookmarkRecipeVC
    }
    func reloadDataInFridgeVC() { recipeInFridgeVC?.reloadCV() }
    func reloadDataInPopularVC() { popularRecipeVC?.reloadCV() }
    
    func getFridgeRecipeList(fridgeType: FridgeType, fridgeIdx: Int) {
        recipeService.getFridgeRecipes(fridgeType: fridgeType, fridgeIdx: fridgeIdx) { response in
            self.recentlyUpdatedList = RecipeListType.recipeInFridge
            self.fridgeRecipeList.removeAll()
            response?.recipeMainResList.forEach { recipe in
                self.fridgeRecipeList.append(recipe)
            }
            self.recipeInFridgeVC?.reloadCV()
        }
    }
    
    func getPopularRecipeList(fridgeType: FridgeType, fridgeIdx: Int) {
        recipeService.getPopularRecipes(fridgeType: fridgeType, fridgeIdx: fridgeIdx) { response in
            self.recentlyUpdatedList = RecipeListType.popularRecipe
            self.popularRecipeList.removeAll()
            response?.recipeMainResList.forEach { recipe in
                self.popularRecipeList.append(recipe)
            }
            self.popularRecipeVC?.reloadCV()
        }
    }
    
    func getBookmarkRecipeList(fridgeType: FridgeType, fridgeIdx: Int) {
        recipeService.getBookmarkRecipes(fridgeType: fridgeType, fridgeIdx: fridgeIdx) { response in
            self.recentlyUpdatedList = RecipeListType.bookmarkRecipe
            self.bookmarkRecipeList.removeAll()
            response?.recipeMainResList.forEach { recipe in
                self.bookmarkRecipeList.append(recipe)
            }
            self.bookmarkRecipeVC?.reloadCV()
        }
    }
    
    func getFridgeRecipeCellInfo(index: Int, completion: @escaping (Recipe?) -> Void) {
        if index < fridgeRecipeList.count {
            completion(fridgeRecipeList[index])
        } else {
            completion(nil)
        }
    }
    
    func getPopularRecipeCellInfo(index: Int, completion: @escaping (Recipe?) -> Void) {
        if index < popularRecipeList.count {
            completion(popularRecipeList[index])
        } else {
            completion(nil)
        }
    }
    
    func getBookmarkRecipeCellInfo(index: Int, completion: @escaping (Recipe) -> Void) {
        completion(bookmarkRecipeList[index])
    }
    
    func updateBookmarkStatus(recipeIdx: Int, completion: @escaping (Bool) -> Void) {
        recipeService.postBookmarkStatus(recipeIdx: recipeIdx) { response in
            completion(response!.status)
        }
    }
}
