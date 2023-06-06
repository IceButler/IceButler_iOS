//
//  AuthService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import AuthenticationServices

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
    
    func loginWithApple(completion: @escaping (ASAuthorizationAppleIDRequest) -> Void) {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.email]
        
        completion(request)
    }
    
    
    
    func requestLogin(parameter: AuthLoginRequest, completion: @escaping (AuthJoinUserResponseModel?) -> Void) {
        APIManger.shared.postData(urlEndpointString: "/users/login", responseDataType: AuthJoinUserResponseModel.self, requestDataType: AuthLoginRequest.self, parameter: parameter) { response in
            completion(response.data)
        }
    }
    
    
    func requestCheckNickname(parameter: AuthNicknameRequsetModel, completion: @escaping (AuthNicknameResponseModel?) -> Void) {
        APIManger.shared.postData(urlEndpointString: "/users/nickname", responseDataType: AuthNicknameResponseModel.self, requestDataType: AuthNicknameRequsetModel.self, parameter: parameter) { response in
            completion(response.data)
        }
    }
    
    func joinUser(parameter: AuthJoinUserRequestModel, completion: @escaping (AuthJoinUserResponseModel?) -> Void) {
        APIManger.shared.postData(urlEndpointString: "/users/join", responseDataType: AuthJoinUserResponseModel.self, requestDataType: AuthJoinUserRequestModel.self, parameter: parameter) { response in
            completion(response.data)
        }
    }
    
    func modfiyUser(parameter: ModfiyUserRequest, completion: @escaping () -> Void) {
        APIManger.shared.patchData(urlEndpointString: "/users/profile", responseDataType: AuthJoinUserResponseModel.self, requestDataType: ModfiyUserRequest.self, parameter: parameter) { response in
            print(response)
            if response.status == "OK" {
                completion()
            }
        }
    }
    
    func requestLogout(completion: @escaping () -> Void) {
        APIManger.shared.postData(urlEndpointString: "/users/logout", responseDataType: AuthNicknameResponseModel.self, requestDataType: AuthLoginRequest.self, parameter: nil) { _ in
            completion()
        }
    }
}
