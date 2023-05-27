//
//  RecipeResponseModel.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/30.
//

import Foundation

struct RecipeResponseModel: Codable {
    let content: [Recipe]
    let pageable: Pageable
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}

struct Recipe: Codable {
    let recipeIdx: Int
    let recipeImgUrl: String
    let recipeName: String
    let recipeCategory: String
    let percentageOfFood: Int
    let recipeLikeStatus: Bool
}

struct MyRecipeResponseModel: Codable {
    let content: [MyRecipe]
    let pageable: Pageable
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}

struct MyRecipe: Codable {
    let recipeIdx: Int
    let recipeImgUrl: String
    let recipeName: String
    let recipeCategory: String
}

struct Pageable: Codable {
    let sort: Sort
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
}

struct Sort: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

struct RecipeDetailResponseModel: Codable {
    let recipeImgUrl: String
    let recipeName: String
    let recipeCategory: String
    let quantity: Int
    let leadTime: Int
    let recipeFoods: [Ingredient]
    let cookery: [Cookery]
    let isSubscribe: Bool
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

struct Cookery: Codable {
    let nextIdx: Int
    let description: String
    let cookeryImgUrl: String?
}

struct RecipeBookmarkResponseModel: Codable {
    let status: Bool
}
