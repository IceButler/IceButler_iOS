//
//  FoodResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import Foundation

struct FoodDetailResponseModel: Codable {
    let fridgeFoodIdx, foodIdx: Int
    let foodName, foodDetailName, foodCategory, shelfLife: String?
    let day, owner: String?
    let memo, imgURL: String?

    enum CodingKeys: String, CodingKey {
        case fridgeFoodIdx, foodIdx, foodName, foodDetailName, foodCategory, shelfLife, day, owner, memo
        case imgURL = "imgUrl"
    }
}


struct FoodOwnerResponseModel: Codable {
    let userList: [FoodOwner]
}

struct FoodOwner: Codable {
    let userIdx: Int
    let nickname, profileImage: String?
}


struct BarcodeFoodResponse: Codable {
    let foodIdx: Int?
    let foodName, foodDetailName, foodCategory: String?
}
