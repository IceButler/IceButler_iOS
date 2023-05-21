//
//  FoodService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import Foundation
import Alamofire

class FoodService {
    func getAllFood(foodIdx: Int, completion: @escaping (FoodDetailResponseModel?) -> Void) {
        APIManger.shared.getData(urlEndpointString: APIManger.shared.getFridgeUrl() + "/" + APIManger.shared.getFridgeIdx().description + "/foods/\(foodIdx)", responseDataType: FoodDetailResponseModel.self, requestDataType: FoodDetailResponseModel.self, parameter: nil) { response in
            completion(response.data)
        }
    }
    
    func getFoodOwnerList(completion: @escaping (FoodOwnerResponseModel?) -> Void) {
        APIManger.shared.getData(urlEndpointString: APIManger.shared.getFridgeUrl() + "/" + APIManger.shared.getFridgeIdx().description + "/members", responseDataType: FoodOwnerResponseModel.self, parameter: nil) { response in
            completion(response.data)
        }
    }
    
    func getBarcodeFood(barcode: String, completion: @escaping (BarcodeFoodResponse) -> Void) {
        APIManger.shared.getData(urlEndpointString: "/foods/barcode?code_num=\(barcode)", responseDataType: BarcodeFoodResponse.self, parameter: nil) { response in
            if let data = response.data {
                completion(data)
            }
        }
    }
    
    func postFood(parameter: FoodAddListModel, completion: @escaping (Bool) -> Void) {
        APIManger.shared.postData(urlEndpointString: APIManger.shared.getFridgeUrl() + "/" + APIManger.shared.getFridgeIdx().description + "/food", responseDataType: FoodDetailResponseModel.self, requestDataType: FoodAddListModel.self, parameter: parameter) { response in
            if response.status == "OK" {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func patchFood(foodIdx: Int, parameter: FoodAddRequestModel, completion: @escaping (Bool) -> Void) {
        APIManger.shared.patchData(urlEndpointString: APIManger.shared.getFridgeUrl() + "/" + APIManger.shared.getFridgeIdx().description + "/foods/\(foodIdx)", responseDataType: FoodDetailResponseModel.self, requestDataType: FoodAddRequestModel.self, parameter: parameter) { response in
            if response.status == "OK" {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func getGptFoodName(foodDetailName: String, completion: @escaping (GptFoodNameResponse) -> Void) {
        let parameter: Parameters =  ["keyword" : foodDetailName]
        APIManger.shared.getGpt(url: "https://za8hqdiis4.execute-api.ap-northeast-2.amazonaws.com/dev/chatgpt-oneword", responseDataType: GptFoodNameResponse.self, parameter: parameter) { response in
            if let response = response {
                completion(response)
            }
        }
    }
    
    func getGptFoodCategory(foodDetailName: String, completion: @escaping (GptCategoryResponse) -> Void) {
        let parameter: Parameters =  ["keyword" : foodDetailName]
        APIManger.shared.getGpt(url: "https://za8hqdiis4.execute-api.ap-northeast-2.amazonaws.com/dev/chatgpt-category", responseDataType: GptCategoryResponse.self, parameter: parameter) { response in
            if let response = response {
                completion(response)
            }
        }
    }
    
    func getSearchFood(word: String, completion: @escaping ([SearchFoodResponse]?) -> Void) {
        let parameter: Parameters = ["word" : word]
        
        APIManger.shared.getListData(urlEndpointString: "/foods", responseDataType: SearchFoodResponse.self, parameter: parameter) { response in
            completion(response.data)
        }
        
    }
    
    
    func getFridgeSearchFood(word: String, completion: @escaping ([FridgeSearchFoodResponse]?) -> Void) {
        let parameter: Parameters = ["keyword" : word]
        
        APIManger.shared.getListData(urlEndpointString: APIManger.shared.getFridgeUrl() + "/" + APIManger.shared.getFridgeIdx().description + "/search", responseDataType: FridgeSearchFoodResponse.self, parameter: parameter) { response in
            completion(response.data)
        }
        
    }
}
