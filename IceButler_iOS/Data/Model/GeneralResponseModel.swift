//
//  GeneralResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import Foundation

struct GeneralResponseModel<T: Codable>: Codable {
    let data: T?
    let transactionTime, status, description: String?
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case data
        case transactionTime = "transaction_time"
        case status, description, statusCode
    }
}


struct GeneralResponseListModel<T: Codable>: Codable {
    let data: [T]?
    let transactionTime, status, description: String?
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case data
        case transactionTime = "transaction_time"
        case status, description, statusCode
    }
}
