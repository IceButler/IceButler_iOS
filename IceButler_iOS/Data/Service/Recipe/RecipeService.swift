//
//  RecipeService.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/30.
//

import Foundation
import Alamofire

class RecipeService {
    
    func getFridgeRecipes(fridgeType: FridgeType, fridgeIdx: Int, completion: @escaping (RecipeResponseModel?) -> Void) {
        let parameter: Parameters = ["category" : "냉장고"]
        switch fridgeType {
        case .homeUse:
            APIManger.shared.getRecipeData(urlEndpointString: "/recipes/\(fridgeIdx)", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response.data)
            }
        case .multiUse:
            APIManger.shared.getRecipeData(urlEndpointString: "/recipes/\(fridgeIdx)", responseDataType: RecipeResponseModel.self, parameter: parameter) { response in
                completion(response.data)
            }
        }
    }
}
