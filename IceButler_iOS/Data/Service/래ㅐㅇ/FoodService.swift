//
//  FoodService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import Foundation

class FoodService {
    func getAllFood(fridgeIdx: Int, foodIdx: Int, completion: @escaping (FoodDetailResponseModel?) -> Void) {
        APIManger.shared.getData(urlEndpointString: "/fridges/\(fridgeIdx)/foods/\(foodIdx)", responseDataType: FoodDetailResponseModel.self, requestDataType: FoodDetailResponseModel.self, parameter: nil) { response in
            completion(response.data)
        }
    }
    
    func getFoodOwnerList(fridgeIdx: Int, completion: @escaping (FoodOwnerResponseModel?) -> Void) {
        APIManger.shared.getData(urlEndpointString: "/fridges/\(fridgeIdx)/members", responseDataType: FoodOwnerResponseModel.self, parameter: nil) { response in
            completion(response.data)
        }
    }
    
    func postFood(fridgeIdx: Int, parameter: FoodAddRequestModel, completion: @escaping (Bool) -> Void) {
        APIManger.shared.postData(urlEndpointString: "/fridges/\(fridgeIdx)/food", responseDataType: FoodDetailResponseModel.self, requestDataType: FoodAddRequestModel.self, parameter: parameter) { response in
            if response.status == "OK" {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
}
