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
    
    private var cancelLabels: Set<AnyCancellable> = []
    
    func userEmail(completion: @escaping (String) -> Void) {
        $userEmail.filter { userEmail in
            userEmail != nil || userEmail != ""
        }.sink { userEmail in
            completion(userEmail!)
        }.store(in: &cancelLabels)
    }
    
    func isUserEmail(completion: @escaping () -> Void) {
        $userEmail.filter { userEmail in
            userEmail != nil || userEmail != ""
        }.sink { userEmail in
            completion()
        }.store(in: &cancelLabels)
    }
    
    
    
    
    func loginWithKakao() {
        authService.loginWithKakao { userEmail in
            self.userEmail = userEmail
        }
    }
}
