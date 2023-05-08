//
//  UserResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/14.
//

import Foundation

struct UserInfoResponseModel: Codable {
    let userIdx: Int
    let nickname, email: String?
    let profileImgUrl: String?
}

//struct MemberResponseModel: Codable {
//    let nickname: String
//    let userIdx: Int
//    let profileImgUrl: String?
//}

struct UserIndexModel: Codable {
    let userIdx: Int
}
