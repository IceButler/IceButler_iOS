//
//  RecipeCategory.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/28.
//

import Foundation

enum RecipeCategory: String, CaseIterable {
    case soup_stew_hotpot = "국/찌개/전골"
    case rice_porridge_noodles = "밥/죽/면"
    case sideDish = "반찬"
    case dessert = "디저트"
    case salad = "샐러드"
    case tea_beverage_alcohol = "차/음료/술"
    case etc = "기타"
}

enum RecipeListType: String, CaseIterable {
    case popularRecipe = "인기 레시피"
    case recipeInFridge = "냉장고 속 레시피"
}

enum RecipeSearchUICategory: String, CaseIterable {
    case recipeName = "레시피명"
    case ingredientName = "재료명"
}

enum RecipeSearchAPICategory: String, CaseIterable {
    case recipe = "레시피"
    case food = "음식"
}

enum RecipeType: CaseIterable {
    case popular
    case fridge
    case bookmark
    case myrecipe
    case search
}
