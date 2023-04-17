//
//  UserService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/16.
//

import Foundation

class UserService {
    func getUserInfo(completion: @escaping (UserInfoResponseModel) -> Void) {
        APIManger.shared.getData(urlEndpointString: "/users", responseDataType: UserInfoResponseModel.self, parameter: nil) { response in
            if let userInfo = response.data {
                completion(userInfo)
            }
        }
    }
}
