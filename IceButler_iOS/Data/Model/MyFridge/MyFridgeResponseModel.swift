//
//  MyFridgeResponseModel.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/24.
//

import Foundation

struct MyFridgeResponseModel: Codable {
    let fridgeList: [Fridge]?
    let multiFridgeResList: [MultiFridgeRes]?
}

struct Fridge: Codable {
    let fridgeIdx: Int?
    let fridgeName, comment: String?
    let users: [User]?
    let userCnt: Int?
}

struct MultiFridgeRes: Codable {
    let multiFridgeIdx: Int?
    let multiFridgeName, comment: String?
    let users: [User]?
    let userCnt: Int?
}

struct User: Codable {
    let nickname, role, profileImage: String?
}
