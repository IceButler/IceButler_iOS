//
//  CartResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import Foundation

struct CartResponseModel: Codable {
    let foods: [Food]
}

struct Food: Codable {
    let foodIdx: Int
    let foodName, foodCategory: String
}
