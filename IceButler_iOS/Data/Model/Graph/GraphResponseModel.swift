//
//  GraphResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/07.
//

import Foundation

struct GraphResponseModel: Codable {
    let foodStatisticsList: [FoodGraphList]
}

struct FoodGraphList: Codable {
    let foodCategory: String
    let percentage: Double
    let count: Int
}
