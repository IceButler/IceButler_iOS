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
    let users: [FridgeUser]?
    let userCnt: Int?
}

struct MultiFridgeRes: Codable {
    let multiFridgeIdx: Int?
    let multiFridgeName, comment: String?
    let users: [FridgeUser]?
    let userCnt: Int?
}

struct FridgeUser: Codable {
    let nickname, role, profileImgUrl: String?
}

// MARK: 공용/가정용 냉장고의 공통 모델
struct CommonFridgeModel {
    let idx: Int?
    let name, comment: String?
    let users: [FridgeUser]?
    let userCnt: Int?
}
