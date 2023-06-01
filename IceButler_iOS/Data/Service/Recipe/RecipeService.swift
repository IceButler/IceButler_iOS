//
//  RecipeService.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/30.
//

import Foundation
import Alamofire

class RecipeService {
    var PAGING_SIZE: Int = 12
    
    func getFridgeRecipes(fridgeType: FridgeType, fridgeIdx: Int, pageNumberToLoad: Int, completion: @escaping (GeneralResponseModel<RecipeResponseModel>?) -> Void) {
        let parameter: Parameters = ["category" : "냉장고", "page" : pageNumberToLoad, "size" : PAGING_SIZE]
        switch fridgeType {
        case .homeUse:
            print("\(fridgeIdx) - 가정용")
            APIManger.shared.getRecipeData(urlEndpointString: "/recipes/\(fridgeIdx)", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response)
            }
        case .multiUse:
            print("\(fridgeIdx) - 공용")
            APIManger.shared.getRecipeData(urlEndpointString: "/multiRecipes/\(fridgeIdx)", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response)
            }
        }
    }
    
    func getPopularRecipes(fridgeType: FridgeType, fridgeIdx: Int, pageNumberToLoad: Int, completion: @escaping (GeneralResponseModel<RecipeResponseModel>?) -> Void) {
        let parameter: Parameters = ["category" : "인기", "page" : pageNumberToLoad, "size" : PAGING_SIZE]
        switch fridgeType {
        case .homeUse:
            print("\(fridgeIdx) - 가정용")
            APIManger.shared.getRecipeData(urlEndpointString: "/recipes/\(fridgeIdx)", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response)
            }
        case .multiUse:
            print("\(fridgeIdx) - 공용")
            APIManger.shared.getRecipeData(urlEndpointString: "/multiRecipes/\(fridgeIdx)", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response)
            }
        }
    }
    
    func getBookmarkRecipes(fridgeType: FridgeType, fridgeIdx: Int, pageNumberToLoad: Int, completion: @escaping (GeneralResponseModel<RecipeResponseModel>?) -> Void) {
        let parameter: Parameters = ["page" : pageNumberToLoad, "size" : PAGING_SIZE]
        switch fridgeType {
        case .homeUse:
            APIManger.shared.getRecipeData(urlEndpointString: "/recipes/\(fridgeIdx)/bookmark", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response)
            }
        case .multiUse:
            APIManger.shared.getRecipeData(urlEndpointString: "/multiRecipes/\(fridgeIdx)/bookmark", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response)
            }
        }
    }
    
    func getMyRecipes(pageNumberToLoad: Int, completion: @escaping (GeneralResponseModel<MyRecipeResponseModel>?) -> Void) {
        let parameter: Parameters = ["page" : pageNumberToLoad, "size" : PAGING_SIZE]
        APIManger.shared.getRecipeData(urlEndpointString: "/recipes/myrecipe", responseDataType: MyRecipeResponseModel.self, parameter: parameter) { response in
            completion(response)
        }
    }
    
    func getSearchRecipes(fridgeIdx: Int, fridgeType: FridgeType, category: String, keyword: String, pageNumberToLoad: Int, completion: @escaping (RecipeResponseModel?) -> Void) {
        let parameter: Parameters = ["keyword" : keyword, "page" : pageNumberToLoad, "size" : PAGING_SIZE, "category" : category]
        switch fridgeType {
        case .homeUse:
            APIManger.shared.getRecipeData(urlEndpointString: "/recipes/search/\(fridgeIdx)", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response.data)
            }
        case .multiUse:
            APIManger.shared.getRecipeData(urlEndpointString: "/multiRecipes/search/\(fridgeIdx)", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response.data)
            }
        }
    }
    
    func getRecipeDetail(recipeIdx: Int, completion: @escaping (GeneralResponseModel<RecipeDetailResponseModel>?) -> Void) {
        APIManger.shared.getRecipeData(urlEndpointString: "/recipes/detail/\(recipeIdx)", responseDataType: RecipeDetailResponseModel.self, parameter: nil) { response in
            completion(response)
        }
    }
    
    func postBookmarkStatus(recipeIdx: Int, completion: @escaping (RecipeBookmarkResponseModel?) -> Void) {
        APIManger.shared.postRecipeData(urlEndpointString: "/recipes/\(recipeIdx)/bookmark", responseDataType: RecipeBookmarkResponseModel.self) { response in
            completion(response.data)
        }
    }
    
    func postRecipe(parameter: RecipeAddRequestModel, completion: @escaping (Bool) -> Void) {
        APIManger.shared.postRecipeData(urlEndpointString: "/recipes", responseDataType: RecipeResponseModel.self, requestDataType: RecipeAddRequestModel.self, parameter: parameter) { response in
            print(response)
            if response.status == "OK" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func modifyRecipe(recipeIdx: Int, parameter: RecipeModifyRequestModel, completion: @escaping (Bool) -> Void) {
        APIManger.shared.patchRecipeData(urlEndpointString: "/recipes/\(recipeIdx)/modify", responseDataType: RecipeResponseModel.self, requestDataType: RecipeModifyRequestModel.self, parameter: parameter) { response in
            print(response)
            if response.status == "OK" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func deleteRecipe(recipeIdx: Int, completion: @escaping (Bool) -> Void) {
        APIManger.shared.deleteRecipeData(urlEndpointString: "/recipes/\(recipeIdx)/myrecipe", responseDataType: RecipeResponseModel.self) { response in
            print(response)
            if response.status == "OK" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func reportRecipe(recipeIdx: Int, parameter: RecipeReportRequestModel, completion: @escaping (Bool) -> Void) {
        APIManger.shared.postRecipeData(urlEndpointString: "/recipes/\(recipeIdx)/report", responseDataType: RecipeResponseModel.self, requestDataType: RecipeReportRequestModel.self, parameter: parameter) { response in
            print(response)
            if response.status == "OK" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
