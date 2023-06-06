//
//  FridgeResponseModel'.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import Foundation

struct FridgeResponseModel: Codable {
    let fridgeDiscard: FridgeDiscard
    let foodList: [FridgeFood]
}

struct FridgeDiscard: Codable {
    let discardFoodCategory, discardFoodImgUrl: String?
}

struct FridgeFood: Codable {
    let fridgeFoodIdx: Int
    let foodName: String
    let foodImgUrl: String
    let shelfLife: Int
}

