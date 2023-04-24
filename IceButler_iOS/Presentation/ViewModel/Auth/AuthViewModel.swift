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

class AuthViewModel: ObservableObject {
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
        $accessToken.filter { token in
            token != nil
        }.sink { token in
            completion(token!)
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
    
    func login(userEmail: String) {
        let parameter = AuthLoginRequest(email: userEmail, provider: self.authProvider!.rawValue)
        
        authService.requestLogin(parameter: parameter) { response in
            if let response = response {
                self.accessToken = response.accessToken
                self.setUserToken(token: response)
            }
        }
        self.userEmail = userEmail
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
            parameter = AuthJoinUserRequestModel(email: userEmail!, provider: (authProvider?.rawValue)!, nickname: userNickname!, profileImgKey: profileImageKey)
        }else {
            parameter = AuthJoinUserRequestModel(email: userEmail!, provider: (authProvider?.rawValue)!, nickname: userNickname!, profileImgKey: nil)
        }
        
        self.authService.joinUser(parameter: parameter) { response in
            if let response = response {
                self.accessToken = response.accessToken
                self.setUserToken(token: response)
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
            self.isJoin = true
        }
    }
    
    func getUserToken() {
        if UserDefaults.standard.value(forKey: "UserToken") == nil {
            self.isJoin = false
        }else {
            if let userTokenData = UserDefaults.standard.object(forKey: "UserToken") as? Data {
                let decoder = JSONDecoder()
                if let userToken = try? decoder.decode(AuthJoinUserResponseModel.self, from: userTokenData) {
                    print(userToken.accessToken)
                    self.accessToken = userToken.accessToken
                    self.isJoin = true
                }
            }
        }
    }

    func logout() {
        authService.requestLogout {
            self.isJoin = false
            UserDefaults.standard.removeObject(forKey: "UserToken")
        }
    }
}
