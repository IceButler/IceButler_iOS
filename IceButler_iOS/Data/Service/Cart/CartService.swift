//
//  CartService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import Foundation


class CartService {
    func getCartFoodList(cartId: Int, completion: @escaping ([CartResponseModel]?) -> Void) {
        APIManger.shared.getData(urlEndpointString: "/carts/\(cartId)/foods",
                                 responseDataType: [CartResponseModel].self,
                                 requestDataType: [CartResponseModel].self,
                                 parameter: nil) { response in
            completion(response.data)
        }
    }
    
    func deleteCartFood(cartId: Int, removeFoodIdxes: [Int], completion: @escaping ([CartResponseModel]?) -> Void) {
        let param = CartRemoveRequestModel(foodIdxes: removeFoodIdxes)
        APIManger.shared.deleteData(urlEndpointString: "/carts/\(cartId)/foods",
                                    responseDataType: [CartResponseModel].self,
                                    requestDataType: CartRemoveRequestModel.self,
                                    parameter: param,
                                    completionHandler: { response in
            completion(response.data as? [CartResponseModel])
        })
    }
    
    func postFoodsAdd(cartId: Int, foods: [AddFood]) {
        let param = AddFoodRequestModel(foodRequests: foods)
        APIManger.shared.postData(urlEndpointString: "/carts/\(cartId)/foods",
                                  responseDataType: AddFoodRequestModel.self,
                                  requestDataType: AddFoodRequestModel.self,
                                  parameter: param,
                                  completionHandler: { response in
            print("식품 추가 API 호출 결과 --> \(response)")
        })
    }
}
