//
//  AuthViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    private let authService = AuthService()
    
    @Published var userEmail: String?
    @Published var userNickName: String?
    @Published var isExistence: Bool?
    
    private var cancelLabels: Set<AnyCancellable> = []
    
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
    
    func userNickName(completion: @escaping (String) -> Void) {
        $userNickName.filter { nickName in
            nickName != nil
        }.sink { nickName in
            completion(nickName!)
        }.store(in: &cancelLabels)
    }
    
    func isExistence(completion: @escaping (Bool) -> Void) {
        $isExistence.filter { isExistence in
            isExistence != nil
        }.sink { isExistence in
            completion(isExistence!)
        }.store(in: &cancelLabels)
    }
    
    func loginWithKakao() {
        authService.loginWithKakao { userEmail in
            self.userEmail = userEmail
        }
    }
    
    func checkNickName(nickName: String) {
        let parameter = AuthNickNameRequsetModel(nickName: nickName)
        authService.requestCheckNickName(parameter: parameter) { response in
            if response != nil {
                self.userNickName = response?.nickName
                self.isExistence = response?.existence
            }else {
                self.userNickName = nickName
                self.isExistence = false
            }
        }
    }
}
