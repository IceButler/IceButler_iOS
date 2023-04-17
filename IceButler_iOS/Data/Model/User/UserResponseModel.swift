//
//  UserResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/14.
//

import Foundation

struct UserInfoResponseModel: Codable {
    let userIdx: Int
    let nickName, email: String?
    let profileImage: String?
}
