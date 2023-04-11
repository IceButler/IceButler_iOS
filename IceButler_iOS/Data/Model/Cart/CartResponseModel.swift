//
//  CartResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import Foundation

struct CartResponseModel: Codable {
    let category: String
    let cartFoods: [CartFood]
}
struct CartFood: Codable {
    let foodIdx: Int?
    let foodName, foodIconName: String?
}
