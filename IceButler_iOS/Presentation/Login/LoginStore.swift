//
//  LoginCore.swift
//  IceButler_iOS
//
//  Created by 유상 on 7/3/24.
//

import Foundation
import ComposableArchitecture
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import AuthenticationServices

public struct LoginStore: Reducer {
    public init() {}
    
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        case kakaoLogin
        case appleLogin
        case moveToNickname
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .kakaoLogin:
                if kakaoLogin() {
                    return .send(.moveToNickname)
                }else {
                    return .none
                }
            case .appleLogin:
                if appleLogin() {
                    return .send(.moveToNickname)
                }else {
                    return .none
                }
            case .moveToNickname:
                return .none
            }
        }
    }
}

public extension LoginStore {
    private func kakaoLogin() -> Bool {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                print(oauthToken)
                print(error)
            }
        }else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                print(oauthToken)
                print(error)
            }
        }
        
        print("kakao login")
        
        return false
    }
    
    private func appleLogin() -> Bool {
        print("apple login")
        return false
    }
}
