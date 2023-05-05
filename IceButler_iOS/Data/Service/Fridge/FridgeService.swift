//
//  FridgeService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import Foundation
import Alamofire

class FridgeService {
    private var urlStr = ""
    
    private func setUrl() {
        if APIManger.shared.getIsMultiFridge() {
            urlStr = "/multiFridges/\(APIManger.shared.getFridgeIdx())/foods"
        } else {
            urlStr = "/fridges/\(APIManger.shared.getFridgeIdx())/foods"
        }
    }
    
    func getAllFood(fridgeIdx: Int, completion: @escaping (FridgeResponseModel?) -> Void) {
//        APIManger.shared.getData(urlEndpointString: "/fridges/\(fridgeIdx)/foods", responseDataType: FridgeResponseModel.self, requestDataType: FridgeResponseModel.self, parameter: nil) { response in
//            completion(response.data)
//        }

        setUrl()
        APIManger.shared.getData(urlEndpointString: urlStr,
                                 responseDataType: FridgeResponseModel.self,
                                 requestDataType: FridgeResponseModel.self,
                                 parameter: nil) { response in
            completion(response.data)
        }
    }
    
    func getCategoryFood(fridgeIdx: Int, category: String,  completion: @escaping (FridgeResponseModel?) -> Void) {
        let parameter: Parameters = ["category" : category]
//        APIManger.shared.getData(urlEndpointString: "/fridges/\(fridgeIdx)/foods", responseDataType: FridgeResponseModel.self, parameter: parameter) {  response in
//            completion(response.data)
//        }
        setUrl()
        APIManger.shared.getData(urlEndpointString: urlStr,
                                 responseDataType: FridgeResponseModel.self,
                                 parameter: parameter) {  response in
            completion(response.data)
        }
    }
    
    func getMemberSearchResults(nickname: String, completion: @escaping ([MemberResponseModel]?) -> Void) {
        let param: Parameters = ["nickname" : nickname]
        APIManger.shared.getData(urlEndpointString: "/users/search",
                                 responseDataType: [MemberResponseModel].self,
                                 parameter: param,
                                 completionHandler: { response in
            print(response)
            completion(response.data)
        })
    }
    
    func addFridge(name: String, comment: String, members: [Int], completion: @escaping ((Int?) -> Void)) {
        let req = FridgeRequestModel(fridgeName: name, fridgeComment: comment, members: members)
        APIManger.shared.postData(urlEndpointString: "/fridges/register",
                                  responseDataType: Int.self,
                                  requestDataType: FridgeRequestModel.self,
                                  parameter: req,
                                  completionHandler: { response in
            print(response)
            completion(response.data)
        })
    }
}
