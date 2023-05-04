//
//  UserViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/14.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    static let shared = UserViewModel()
    private let userService = UserService()
    
    @Published var userInfo: UserInfoResponseModel?
    
    private var cancelLabels: Set<AnyCancellable> = []
    
    func userInfo(completion: @escaping (UserInfoResponseModel) -> Void) {
        $userInfo.filter { userInfo in
            userInfo != nil
        }.sink { userInfo in
            completion(userInfo!)
        }.store(in: &cancelLabels)
    }
    
    
    func getUserInfo() {
        userService.getUserInfo { userInfo in
            self.userInfo = userInfo
        }
    }
    
    func deleteUser() {
        userService.deleteUser { result in
            if result == true {
                AuthViewModel.shared.removeAllData()
            }
        }
    }
    
}
