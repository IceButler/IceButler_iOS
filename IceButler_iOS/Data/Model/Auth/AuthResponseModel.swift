//
//  AuthResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import Foundation

struct AuthNickNameResponseModel: Codable {
    let nickName: String
    let existence: Bool
}


struct AuthJoinUserResponseModel: Codable {
    let accessToken, refreshToken: String
}
