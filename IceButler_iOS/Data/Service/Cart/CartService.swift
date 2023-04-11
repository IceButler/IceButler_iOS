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
        APIManger.shared.putData(urlEndpointString: "/carts/\(cartId)/foods",
                                 responseDataType: [CartResponseModel]?.self,
                                 requestDataType: CartRemoveRequestModel.self,
                                 parameter: param) { response in
            completion(response.data as? [CartResponseModel])
        }
    }
    
    
}
