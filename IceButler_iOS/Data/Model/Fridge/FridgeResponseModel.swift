//
//  FridgeResponseModel'.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import Foundation

struct FridgeResponseModel: Codable {
    let foodList: [FridgeFood]
}

struct FridgeFood: Codable {
    let fridgeFoodIdx: Int
    let foodName: String
    let foodIconName: String?
    let shelfLife: String
}
