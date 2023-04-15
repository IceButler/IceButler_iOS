//
//  AuthRequestModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import Foundation

struct AuthNickNameRequsetModel: Codable {
    let nickName: String
}

struct AuthJoinUserRequestModel: Codable {
    let email, provider, nickName: String
    let profileImgUrl: String?
}
