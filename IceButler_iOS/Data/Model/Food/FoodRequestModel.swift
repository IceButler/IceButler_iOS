//
//  FoodRequestModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import Foundation

struct FoodAddListModel: Codable {
    let fridgeFoods: [FoodAddRequestModel]
}

struct FoodAddRequestModel: Codable {
    let foodName, foodDetailName, foodCategory, shelfLife: String
    let memo, imageUrl: String?
    let ownerIdx: Int
}
