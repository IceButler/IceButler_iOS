//
//  AuthViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import Foundation
import Combine
import UIKit
import Alamofire
import AuthenticationServices

class AuthViewModel: NSObject, ObservableObject {
    static let shared = AuthViewModel()
    private let authService = AuthService()
    
    @Published var userEmail: String?
    @Published var userNickname: String?
    @Published var isExistence: Bool?
    @Published var isJoin: Bool = false
    @Published var accessToken: String?
    @Published var isModify: Bool = false
    
    private var cancelLabels: Set<AnyCancellable> = []
    
    private var authProvider: AuthProvider?
    
    private var profileImgKey: String?
    
    private var deviceToken: String = ""
    
    func setDeviceToken(token: String) {
        deviceToken = token
        print("디바이스 토큰 값 설정됨 --> \(deviceToken)")
    }
    
    func userEmail(completion: @escaping (String) -> Void) {
        $userEmail.filter { userEmail in
            userEmail != nil
        }.sink { userEmail in
            completion(userEmail!)
        }.store(in: &cancelLabels)
    }
    
    func isUserEmail(completion: @escaping () -> Void) {
        $userEmail.filter { userEmail in
            userEmail != nil
        }.sink { userEmail in
            completion()
        }.store(in: &cancelLabels)
    }
    
    func userNickname(completion: @escaping (String) -> Void) {
        $userNickname.filter { nickname in
            nickname != nil
        }.sink { nickname in
            completion(nickname!)
        }.store(in: &cancelLabels)
    }
    
    func isExistence(completion: @escaping (Bool) -> Void) {
        $isExistence.filter { isExistence in
            isExistence != nil
        }.sink { isExistence in
            completion(isExistence!)
        }.store(in: &cancelLabels)
    }
    
    func isJoin(completion: @escaping (Bool) -> Void) {
        $isJoin.sink { isJoin in
            completion(isJoin)
        }.store(in: &cancelLabels)
    }
    
    func isModify(completion: @escaping (Bool) -> Void) {
        $isModify.sink { isModify in
            completion(isModify)
        }.store(in: &cancelLabels)
    }
    
    func accessToken(completion: @escaping (String) -> Void) {
        $accessToken.sink { token in
            completion(token ?? "")
        }.store(in: &cancelLabels)
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
                self.accessToken = response.accessToken
                self.setUserToken(token: response)
            }else {
                self.userEmail = userEmail
            }
        }
    }
    
    
    func checkNickname(nickname: String) {
        let parameter = AuthNicknameRequsetModel(nickname: nickname)
        authService.requestCheckNickname(parameter: parameter) { response in
            if response != nil {
                self.userNickname = response?.nickname
                self.isExistence = response?.existence
            }else {
                self.userNickname = nickname
                self.isExistence = false
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
                self.accessToken = response.accessToken
                self.setUserToken(token: response)
                self.isJoin = true
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
            self.isModify = true
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
                    self.accessToken = userToken.accessToken
                }
            }
        }
    }

    func logout() {
        authService.requestLogout {
            self.removeAllData()
            FridgeViewModel.shared.removeFridgeIdx()
        }
    }
    
    func removeAllData() {
        self.isJoin = false
        self.isModify = false
        self.userEmail = nil
        self.accessToken = nil
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
