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
    var foodName, foodDetailName, foodCategory, shelfLife: String
    var memo, imgKey: String?
    var ownerIdx: Int
}

struct FoodDeleteModel: Codable {
    let deleteFoods: [Int]
}
