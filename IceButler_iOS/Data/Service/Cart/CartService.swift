//
//  CartService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import Foundation


class CartService {
    
    private var urlStr = ""
    func getCartFoodList(completion: @escaping ([CartResponseModel]?) -> Void) {
        
        setUrlStr()
        APIManger.shared.getData(urlEndpointString: urlStr,
                                 responseDataType: [CartResponseModel].self,
                                 requestDataType: [CartResponseModel].self,
                                 parameter: nil) { response in
            completion(response.data)
        }
    }
    
    func deleteCartFood(removeFoodIdxes: [Int], completion: @escaping ([CartResponseModel]?) -> Void) {
        
        setUrlStr()
        let param = CartRemoveRequestModel(foodIdxes: removeFoodIdxes)
        APIManger.shared.deleteData(urlEndpointString: urlStr,
                                    responseDataType: [CartResponseModel].self,
                                    requestDataType: CartRemoveRequestModel.self,
                                    parameter: param,
                                    completionHandler: { response in
            completion(response.data as? [CartResponseModel])
        })
    }
    
    func postFoodsAdd(foods: [AddFood]) {
        setUrlStr()
        let param = AddFoodRequestModel(foodRequests: foods)
        APIManger.shared.postData(urlEndpointString: urlStr,
                                  responseDataType: AddFoodRequestModel.self,
                                  requestDataType: AddFoodRequestModel.self,
                                  parameter: param,
                                  completionHandler: { response in
            print("식품 추가 API 호출 결과 --> \(response)")
        })
    }
    
    private func setUrlStr() {
        let fridgeId = APIManger.shared.getFridgeIdx()
        if APIManger.shared.getIsMultiFridge() { urlStr = "/multiCarts/\(fridgeId)/foods" }
        else { urlStr = "/carts/\(fridgeId)/foods" }
    }
}
