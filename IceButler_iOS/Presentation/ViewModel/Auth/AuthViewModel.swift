//
//  AuthViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import Foundation
import RxSwift
import RxRelay
import UIKit
import Alamofire
import AuthenticationServices

class AuthViewModel: NSObject {
    static let shared = AuthViewModel()
    private let authService = AuthService()
    
    private let userEmailRelay = BehaviorRelay<String?>(value: nil)
    private let userNicknameRelay = BehaviorRelay<String?>(value: nil)
    private let isExistenceRelay = BehaviorRelay<Bool?>(value: nil)
    private let isJoinRelay = BehaviorRelay<Bool>(value: false)
    private let accessTokenRelay = BehaviorRelay<String?>(value: nil)
    private let isModifyRelay = BehaviorRelay<Bool>(value: false)
    
    // Public accessors
    var userEmail: String? { userEmailRelay.value }
    var userNickname: String? { userNicknameRelay.value }
    var isExistence: Bool? { isExistenceRelay.value }
    var isJoin: Bool { isJoinRelay.value }
    var accessToken: String? { accessTokenRelay.value }
    var isModify: Bool { isModifyRelay.value }
    
    private let disposeBag = DisposeBag()
    
    private var authProvider: AuthProvider?
    
    private var profileImgKey: String?
    
    private var deviceToken: String = ""
    
    func setDeviceToken(token: String) {
        deviceToken = token
        print("디바이스 토큰 값 설정됨 --> \(deviceToken)")
    }
    
    func userEmail(completion: @escaping (String) -> Void) {
        userEmailRelay
            .compactMap { $0 }
            .subscribe(onNext: { email in
                completion(email)
            })
            .disposed(by: disposeBag)
    }
    
    func isUserEmail(completion: @escaping () -> Void) {
        userEmailRelay
            .compactMap { $0 }
            .subscribe(onNext: { _ in
                completion()
            })
            .disposed(by: disposeBag)
    }
    
    func userNickname(completion: @escaping (String) -> Void) {
        userNicknameRelay
            .compactMap { $0 }
            .subscribe(onNext: { nickname in
                completion(nickname)
            })
            .disposed(by: disposeBag)
    }
    
    func isExistence(completion: @escaping (Bool) -> Void) {
        isExistenceRelay
            .compactMap { $0 }
            .subscribe(onNext: { isExistence in
                completion(isExistence)
            })
            .disposed(by: disposeBag)
    }
    
    func isJoin(completion: @escaping (Bool) -> Void) {
        isJoinRelay
            .subscribe(onNext: { isJoin in
                completion(isJoin)
            })
            .disposed(by: disposeBag)
    }
    
    func isModify(completion: @escaping (Bool) -> Void) {
        isModifyRelay
            .subscribe(onNext: { isModify in
                completion(isModify)
            })
            .disposed(by: disposeBag)
    }
    
    func accessToken(completion: @escaping (String) -> Void) {
        accessTokenRelay
            .subscribe(onNext: { token in
                completion(token ?? "")
            })
            .disposed(by: disposeBag)
    }
    
    
}

extension AuthViewModel {
    
    func loginWithKakao() {
        authService.loginWithKakao { userEmail in
            self.authProvider = .kakao
            self.login(userEmail: userEmail)
        }
    }
    
    func loginWithApple(completion: @escaping (ASAuthorizationAppleIDRequest) -> Void) {
        authService.loginWithApple { request in
            completion(request)
        }
    }
    
    
    
    
    func login(userEmail: String) {
        let parameter = AuthLoginRequest(email: userEmail, provider: self.authProvider!.rawValue, fcmToken: deviceToken)
        
        authService.requestLogin(parameter: parameter) { response in
            if let response = response {
                self.accessTokenRelay.accept(response.accessToken)
                self.setUserToken(token: response)
            }else {
                self.userEmailRelay.accept(userEmail)
            }
        }
    }
    
    
    func checkNickname(nickname: String) {
        let parameter = AuthNicknameRequsetModel(nickname: nickname)
        authService.requestCheckNickname(parameter: parameter) { response in
            if response != nil {
                self.userNicknameRelay.accept(response?.nickname)
                self.isExistenceRelay.accept(response?.existence)
            }else {
                self.userNicknameRelay.accept(nickname)
                self.isExistenceRelay.accept(false)
            }
        }
    }
    
    func getUploadImageUrl(imageDir: ImageDir, image: UIImage, mode: ProfileEditMode) {
        let parameter: Parameters = ["ext": "jpeg", "dir": imageDir.rawValue]
        ImageService.shared.getImageUrl(parameter: parameter) {[self] response in
            if let response = response {
                profileImgKey = response.imageKey
                uploadProfileImage(image: image, url: response.presignedUrl, mode: mode)
            }
        }
    }
    
    func uploadProfileImage(image: UIImage, url: String, mode: ProfileEditMode) {
        ImageService.shared.uploadImage(image: image, url: url) {
            if mode == .Join {
                self.joinUser()
            }else {
                self.modifyUser()
            }
        }
    }
    
    func joinUser() {
        let parameter: AuthJoinUserRequestModel

        if let profileImageKey = self.profileImgKey {
            parameter = AuthJoinUserRequestModel(email: userEmail!, provider: (authProvider?.rawValue)!, nickname: userNickname!, profileImgKey: profileImageKey, fcmToken: deviceToken)
        }else {
            parameter = AuthJoinUserRequestModel(email: userEmail!, provider: (authProvider?.rawValue)!, nickname: userNickname!, profileImgKey: nil, fcmToken: deviceToken)
        }
        
        self.authService.joinUser(parameter: parameter) { response in
            if let response = response {
                self.accessTokenRelay.accept(response.accessToken)
                self.setUserToken(token: response)
                self.isJoinRelay.accept(true)
            }
        }
    }
    
    func modifyUser() {
        let parameter: ModfiyUserRequest

        if let profileImageKey = self.profileImgKey {
            parameter = ModfiyUserRequest(nickname: userNickname!, profileImgKey: profileImageKey)
        }else {
            parameter = ModfiyUserRequest(nickname: userNickname!, profileImgKey: nil)
        }
        
        self.authService.modfiyUser(parameter: parameter) {
            UserViewModel.shared.getUserInfo()
            self.isModifyRelay.accept(true)
        }
    }
    
    
    func setUserToken(token: AuthJoinUserResponseModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(token) {
            UserDefaults.standard.setValue(encoded, forKey: "UserToken")
        }
    }
    
    func getUserToken() {
        if UserDefaults.standard.value(forKey: "UserToken") != nil {
            if let userTokenData = UserDefaults.standard.object(forKey: "UserToken") as? Data {
                let decoder = JSONDecoder()
                if let userToken = try? decoder.decode(AuthJoinUserResponseModel.self, from: userTokenData) {
                    self.accessTokenRelay.accept(userToken.accessToken)
                }
            }
        }
    }

    func logout() {
        authService.requestLogout {
            self.removeAllData()
            FridgeViewModel.shared.removeFridgeIdx()
            UserViewModel.shared.userInfo = nil
        }
    }
    
    func removeAllData() {
        self.isJoinRelay.accept(false)
        self.isModifyRelay.accept(false)
        self.userEmailRelay.accept(nil)
        self.accessTokenRelay.accept(nil)
        UserDefaults.standard.removeObject(forKey: "UserToken")
    }
}


extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {return}
        
        if let email = credential.email {
            self.authProvider = .apple
            self.login(userEmail: email)
        }else {
            if let tokenString = String(data: credential.identityToken ?? Data(), encoding: .utf8) {
                let email = decode(jwtToken: tokenString)["email"] as? String ?? ""
                self.authProvider = .apple
                self.login(userEmail: email)
           }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 에러")
    }
    
    
    private func decode(jwtToken jwt: String) -> [String: Any] {
        
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }

        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }

            return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
}
