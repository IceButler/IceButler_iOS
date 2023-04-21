//
//  AuthRequestModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import Foundation

struct AuthNicknameRequsetModel: Codable {
    let nickname: String
}

struct AuthJoinUserRequestModel: Codable {
    let email, provider, nickname: String
    let profileImgKey: String?
}

struct AuthLoginRequest: Codable {
    let email, provider: String
}
