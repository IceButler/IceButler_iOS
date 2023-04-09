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
}
