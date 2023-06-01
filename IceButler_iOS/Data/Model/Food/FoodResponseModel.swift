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
    let day: Int
    let owner: String?
    let memo, imgURL: String?

    enum CodingKeys: String, CodingKey {
        case fridgeFoodIdx, foodIdx, foodName, foodDetailName, foodCategory, shelfLife, day, owner, memo
        case imgURL = "imgUrl"
    }
}

struct SearchFoodResponse: Codable {
    let foodIdx: Int
    let foodName, foodCategory, foodImgUrl: String
}

struct FridgeSearchFoodResponse: Codable {
    let fridgeFoodIdx, shelfLife: Int
    let foodName, foodImgUrl: String
}


struct FoodOwnerResponseModel: Codable {
    let fridgeUsers: [FoodOwner]
}

struct FoodOwner: Codable {
    let userIdx: Int
    let nickName, profileImageUrl: String?
}


struct BarcodeFoodResponse: Codable {
    let foodIdx: Int?
    let foodName, foodDetailName, foodCategory: String?
}


struct GptCategoryResponse: Codable {
    let categories: [String]
}

struct GptFoodNameResponse: Codable {
    let words: [String]
}
