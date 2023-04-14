//
//  ImageResponseModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/13.
//

import Foundation

struct ImageResponseModel: Codable {
    let imageKey, presignedUrl: String
}
