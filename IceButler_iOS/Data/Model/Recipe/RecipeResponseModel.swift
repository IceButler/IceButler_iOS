//
//  RecipeResponseModel.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/30.
//

import Foundation

struct RecipeResponseModel: Codable {
    let recipeMainResList: [Recipe]
}

struct Recipe: Codable {
    let recipeIdx: Int
    let recipeImgUrl: String
    let recipeName: String
    let recipeCategory: String
    let percentageOfFood: Int
    let recipeLikeStatus: Bool
}

struct RecipeBookmarkResponseModel: Codable {
    let status: Bool
}
