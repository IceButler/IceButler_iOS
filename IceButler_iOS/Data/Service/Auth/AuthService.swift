//
//  AuthService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import Foundation
import KakaoSDKUser

class AuthService {
    func loginWithKakao(comletion: @escaping (String) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                }else {
                    _ = oauthToken
                    
                    self.getUserEmailWithKakao(comletion: comletion)
                }
            }
        }else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                }else {
                    _ = oauthToken
                    
                    
                    self.getUserEmailWithKakao(comletion: comletion)
                }
            }
        }
    }
    
    func getUserEmailWithKakao(comletion: @escaping (String) -> Void) {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print(error)
            }else {
                comletion(user?.kakaoAccount?.email ?? "")
            }
        }
    }
    
    func requestCheckNickName(parameter: AuthNickNameRequsetModel, completion: @escaping (AuthNickNameResponseModel?) -> Void) {
        APIManger.shared.postData(urlEndpointString: "/users/nickname", responseDataType: AuthNickNameResponseModel.self, requestDataType: AuthNickNameRequsetModel.self, parameter: parameter) { response in
            completion(response.data)
        }
    }
}
