//
//  ImageResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/13.
//

import Foundation

struct ImageResponseModel: Codable {
    let url: String
    let fields: Fields
}

struct Fields: Codable {
    let key, contentType, bucket, xAmzAlgorithm: String
    let xAmzCredential, xAmzDate, policy, xAmzSignature: String

    enum CodingKeys: String, CodingKey {
        case key
        case contentType = "Content-Type"
        case bucket
        case xAmzAlgorithm = "X-Amz-Algorithm"
        case xAmzCredential = "X-Amz-Credential"
        case xAmzDate = "X-Amz-Date"
        case policy = "Policy"
        case xAmzSignature = "X-Amz-Signature"
    }
}
