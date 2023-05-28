//
//  RecipeViewModel.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/29.
//

import Foundation
import Combine
import UIKit
import Alamofire

class RecipeViewModel: ObservableObject {
    static let shared = RecipeViewModel()
    private let recipeService = RecipeService()
    
    @Published var fridgeRecipeList: [Recipe] = []
    @Published var popularRecipeList: [Recipe] = []
    @Published var bookmarkRecipeList: [Recipe] = []
    @Published var myRecipeList: [MyRecipe] = []
    var fridgeIdxOfFridgeRecipe: Int = -1
    var fridgeIdxOfPopularRecipe: Int = -1
    var fridgeTypeOfFridgeRecipe: FridgeType = .homeUse
    var fridgeTypeOfPopularRecipe: FridgeType = .homeUse
    var fridgeRecipeIsLastPage: Bool = false
    var popularRecipeIsLastPage: Bool = false
    var bookmarkRecipeIsLastPage: Bool = false
    var myRecipeIsLastPage: Bool = false
    
    private var recipeInFridgeVC: RecipeInFridgeViewController? = nil
    private var popularRecipeVC: PopularRecipeViewController? = nil
    private var bookmarkRecipeVC: BookmarkRecipeViewController? = nil
    private var myRecipeVC: MyRecipeViewController? = nil
    
    func setRecipeInFridgeVC(recipeInFridgeVC: RecipeInFridgeViewController) {
        self.recipeInFridgeVC = recipeInFridgeVC
    }
    func setPopularRecipeVC(popularRecipeVC: PopularRecipeViewController) {
        self.popularRecipeVC = popularRecipeVC
    }
    func setBookmarkRecipeVC(bookmarkRecipeVC: BookmarkRecipeViewController) {
        self.bookmarkRecipeVC = bookmarkRecipeVC
    }
    func setMyRecipeVC(myRecipeVC: MyRecipeViewController) {
        self.myRecipeVC = myRecipeVC
    }
    
    func getFridgeRecipeList(pageNumberToLoad: Int) {
        var indexArrayToInsert: [IndexPath] = []
        if pageNumberToLoad == 0 {
            self.fridgeRecipeList.removeAll()
            self.fridgeRecipeIsLastPage = false
        }
        recipeService.getFridgeRecipes(fridgeType: fridgeTypeOfFridgeRecipe, fridgeIdx: fridgeIdxOfFridgeRecipe, pageNumberToLoad: pageNumberToLoad) { response in
            response?.content.forEach { recipe in
                indexArrayToInsert.append(IndexPath(item: self.fridgeRecipeList.count, section: 0))
                self.fridgeRecipeList.append(recipe)
            }
            self.fridgeRecipeIsLastPage = response?.last ?? false
            self.recipeInFridgeVC?.updateCV(indexArray: indexArrayToInsert)
        }
    }
    
    func getPopularRecipeList(pageNumberToLoad: Int) {
        var indexArrayToInsert: [IndexPath] = []
        if pageNumberToLoad == 0 {
            self.popularRecipeList.removeAll()
            self.popularRecipeIsLastPage = false
        }
        recipeService.getPopularRecipes(fridgeType: fridgeTypeOfPopularRecipe, fridgeIdx: fridgeIdxOfPopularRecipe, pageNumberToLoad: pageNumberToLoad) { response in
            response?.content.forEach { recipe in
                indexArrayToInsert.append(IndexPath(item: self.popularRecipeList.count, section: 0))
                self.popularRecipeList.append(recipe)
            }
            self.popularRecipeIsLastPage = response?.last ?? false
            self.popularRecipeVC?.updateCV(indexArray: indexArrayToInsert)
        }
    }
    
    func getBookmarkRecipeList(fridgeType: FridgeType, fridgeIdx: Int, pageNumberToLoad: Int) {
        var indexArrayToInsert: [IndexPath] = []
        if pageNumberToLoad == 0 {
            self.bookmarkRecipeList.removeAll()
            self.bookmarkRecipeIsLastPage = false
        }
        recipeService.getBookmarkRecipes(fridgeType: fridgeType, fridgeIdx: fridgeIdx, pageNumberToLoad: pageNumberToLoad) { response in
            response?.content.forEach { recipe in
                indexArrayToInsert.append(IndexPath(item: self.bookmarkRecipeList.count, section: 0))
                self.bookmarkRecipeList.append(recipe)
            }
            self.bookmarkRecipeIsLastPage = response?.last ?? false
            self.bookmarkRecipeVC?.updateCV(indexArray: indexArrayToInsert)
        }
    }
    
    func getMyRecipeList(pageNumberToLoad: Int) {
        var indexArrayToInsert: [IndexPath] = []
        if pageNumberToLoad == 0 {
            self.myRecipeList.removeAll()
            self.myRecipeIsLastPage = false
        }
        recipeService.getMyRecipes(pageNumberToLoad: pageNumberToLoad) { response in
            response?.content.forEach { recipe in
                indexArrayToInsert.append(IndexPath(item: self.myRecipeList.count, section: 0))
                self.myRecipeList.append(recipe)
            }
            self.myRecipeIsLastPage = response?.last ?? false
            self.myRecipeVC?.updateCV(indexArray: indexArrayToInsert)
        }
    }
    
    func getRecipeDetail(recipeIdx: Int, completion: @escaping (GeneralResponseModel<RecipeDetailResponseModel>?) -> Void) {
        recipeService.getRecipeDetail(recipeIdx: recipeIdx) { response in
            completion(response)
        }
    }
    
    func getFridgeRecipeCellInfo(index: Int, completion: @escaping (Recipe) -> Void) {
        completion(fridgeRecipeList[index])
    }
    
    func getPopularRecipeCellInfo(index: Int, completion: @escaping (Recipe) -> Void) {
        completion(popularRecipeList[index])
    }
    
    func getBookmarkRecipeCellInfo(index: Int, completion: @escaping (Recipe) -> Void) {
        completion(bookmarkRecipeList[index])
    }
    
    func getMyRecipeCellInfo(index: Int, completion: @escaping (MyRecipe) -> Void) {
        completion(myRecipeList[index])
    }
    
    func updateBookmarkStatus(recipeIdx: Int, completion: @escaping (Bool) -> Void) {
        recipeService.postBookmarkStatus(recipeIdx: recipeIdx) { response in
            completion(response!.status)
        }
    }
    
    func postRecipe(recipeImg: UIImage,
                    recipeName: String,
                    category: String,
                    amount: Int,
                    timeRequired: Int,
                    ingredientList: [[String]],
                    cookingProcessList: [[Any?]],
                    completion: @escaping (Bool) -> Void) async throws {
        let thumbnailParameter: Parameters = ["ext": "jpeg", "dir": ImageDir.RecipeThumbnail.rawValue]
        let recipeImageParameter: Parameters = ["ext": "jpeg", "dir": ImageDir.RecipeImage.rawValue]
        var thumbnailImgKey: String?
        var thumbnailUrl: String?
        var recipeImgKeyList: [String?] = []
        var recipeUrlList: [String?] = []
        var foodList: [Ingredient] = []
        var cookeryList: [CookingProcess] = []
        var isEmptyUrlList: Bool = true
        
        // get ImageKey
        let thumbnailResponse = try await ImageService.shared.getRecipeImageUrl(parameter: thumbnailParameter)
        thumbnailImgKey = thumbnailResponse?.imageKey
        thumbnailUrl = thumbnailResponse?.presignedUrl
        
        for i in cookingProcessList.indices {
            if cookingProcessList[i][0] == nil {
                recipeImgKeyList.append(nil)
                recipeUrlList.append(nil)
            } else {
                isEmptyUrlList = false
                let response = try await ImageService.shared.getRecipeImageUrl(parameter: recipeImageParameter)
                recipeImgKeyList.append(response?.imageKey)
                recipeUrlList.append(response?.presignedUrl)
            }
        }
        
        // 재료 list
        for i in ingredientList.indices {
            foodList.append(Ingredient(foodName: ingredientList[i][0], foodDetail: ingredientList[i][1]))
        }
        // 조리과정 list
        for i in cookingProcessList.indices {
            if cookingProcessList[i][0] != nil {
                cookeryList.append(CookingProcess(cookeryImgKey: recipeImgKeyList[i], cookeryDescription: (cookingProcessList[i][1] as? String)!))
            } else {
                cookeryList.append(CookingProcess(cookeryImgKey: nil, cookeryDescription: (cookingProcessList[i][1] as? String)!))
            }
        }
        
        // post api 연결
        if cookeryList.count == cookingProcessList.count {
            let parameter = RecipeAddRequestModel(recipeName: recipeName, recipeImgKey: thumbnailImgKey!, recipeCategory: category, leadTime: timeRequired, quantity: amount, foodList: foodList, cookeryList: cookeryList)
            self.recipeService.postRecipe(parameter: parameter) { result in
                if result {
                    // upload Image
                    ImageService.shared.uploadRecipeImage(image: recipeImg, url: thumbnailUrl!) {
                        if isEmptyUrlList {
                            completion(true)
                        }
                        for i in cookingProcessList.indices {
                            if cookingProcessList[i][0] != nil {
                                ImageService.shared.uploadRecipeImage(image: cookingProcessList[i][0] as! UIImage, url: recipeUrlList[i]!) {
                                    completion(true)
                                }
                            }
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func modifyRecipe(recipeIdx: Int,
                      recipeImg: UIImage,
                      recipeName: String,
                      category: String,
                      amount: Int,
                      timeRequired: Int,
                      ingredientList: [[String]],
                      cookingProcessList: [[Any?]],
                      completion: @escaping (Bool) -> Void) async throws {
        let thumbnailParameter: Parameters = ["ext": "jpeg", "dir": ImageDir.RecipeThumbnail.rawValue]
        let recipeImageParameter: Parameters = ["ext": "jpeg", "dir": ImageDir.RecipeImage.rawValue]
        var thumbnailImgKey: String?
        var thumbnailUrl: String?
        var recipeImgKeyList: [String?] = []
        var recipeUrlList: [String?] = []
        var foodList: [Ingredient] = []
        var cookeryList: [CookingProcess] = []
        var isEmptyUrlList: Bool = true
        
        // get ImageKey
        let thumbnailResponse = try await ImageService.shared.getRecipeImageUrl(parameter: thumbnailParameter)
        thumbnailImgKey = thumbnailResponse?.imageKey
        thumbnailUrl = thumbnailResponse?.presignedUrl
        
        for i in cookingProcessList.indices {
            if cookingProcessList[i][0] == nil {
                recipeImgKeyList.append(nil)
                recipeUrlList.append(nil)
            } else {
                isEmptyUrlList = false
                let response = try await ImageService.shared.getRecipeImageUrl(parameter: recipeImageParameter)
                recipeImgKeyList.append(response?.imageKey)
                recipeUrlList.append(response?.presignedUrl)
            }
        }
        
        // 재료 list
        for i in ingredientList.indices {
            foodList.append(Ingredient(foodName: ingredientList[i][0], foodDetail: ingredientList[i][1]))
        }
        // 조리과정 list
        for i in cookingProcessList.indices {
            if cookingProcessList[i][0] != nil {
                cookeryList.append(CookingProcess(cookeryImgKey: recipeImgKeyList[i], cookeryDescription: (cookingProcessList[i][1] as? String)!))
            } else {
                cookeryList.append(CookingProcess(cookeryImgKey: nil, cookeryDescription: (cookingProcessList[i][1] as? String)!))
            }
        }
        
        // patch api 연결
        if cookeryList.count == cookingProcessList.count {
            let parameter = RecipeModifyRequestModel(recipeName: recipeName, recipeImgKey: thumbnailImgKey!, recipeCategory: category, leadTime: timeRequired, quantity: amount, foodList: foodList, cookeryList: cookeryList)
            self.recipeService.modifyRecipe(recipeIdx: recipeIdx, parameter: parameter) { result in
                if result {
                    // upload Image
                    ImageService.shared.uploadRecipeImage(image: recipeImg, url: thumbnailUrl!) {
                        if isEmptyUrlList {
                            completion(true)
                        }
                        for i in cookingProcessList.indices {
                            if cookingProcessList[i][0] != nil {
                                ImageService.shared.uploadRecipeImage(image: cookingProcessList[i][0] as! UIImage, url: recipeUrlList[i]!) {
                                    completion(true)
                                }
                            }
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func deleteRecipe(recipeIdx: Int, completion: @escaping (Bool) -> Void) {
        recipeService.deleteRecipe(recipeIdx: recipeIdx) { result in
            completion(result)
        }
    }
    
    func reportRecipe(recipeIdx: Int, reason: String, completion: @escaping (Bool) -> Void) {
        let parameter = RecipeReportRequestModel(reason: reason)
        recipeService.reportRecipe(recipeIdx: recipeIdx, parameter: parameter) { result in
            completion(result)
        }
    }
}
