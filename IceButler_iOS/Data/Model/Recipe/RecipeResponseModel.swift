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

struct RecipeAddRequestModel: Codable {
    let recipeName: String
    let recipeImgKey: String
    let recipeCategory: String
    let leadTime: Int
    let quantity: Int
    let foodList: [Ingredient]
    let cookeryList: [CookingProcess]
}

struct Ingredient: Codable {
    let foodName: String
    let foodDetail: String
}

struct CookingProcess: Codable {
    let cookeryImgKey: String?
    let cookeryDescription: String
}
