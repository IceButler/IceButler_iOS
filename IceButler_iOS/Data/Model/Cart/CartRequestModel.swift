//
//  CartRequestModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import Foundation

struct CartRemoveRequestModel: Codable {
    let foodIdxes: [Int]
}

struct AddFoodRequestModel: Codable {
    let foodRequests: [AddFood]?
}
struct AddFood: Codable {
    let foodName, foodCategory: String?
}
