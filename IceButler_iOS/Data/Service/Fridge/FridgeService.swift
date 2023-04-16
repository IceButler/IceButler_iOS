//
//  FridgeService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import Foundation
import Alamofire

class FridgeService {
    func getAllFood(fridgeIdx: Int, completion: @escaping (FridgeResponseModel?) -> Void) {
        APIManger.shared.getData(urlEndpointString: "/fridges/\(fridgeIdx)/foods", responseDataType: FridgeResponseModel.self, requestDataType: FridgeResponseModel.self, parameter: nil) { response in
            completion(response.data)
        }
    }
    
    func getCategoryFood(fridgeIdx: Int, category: String,  completion: @escaping (FridgeResponseModel?) -> Void) {
        let parameter: Parameters = ["category" : category]
        APIManger.shared.getData(urlEndpointString: "/fridges/\(fridgeIdx)/foods", responseDataType: FridgeResponseModel.self, parameter: parameter) {  response in
            completion(response.data)
        }
    }
}
