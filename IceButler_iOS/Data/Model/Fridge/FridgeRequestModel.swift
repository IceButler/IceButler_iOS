//
//  FridgeRequestModel.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/07.
//

import Foundation

struct FridgeRequestModel: Codable {
    let fridgeName, fridgeComment: String
    let members: [Int]
}

struct EditedFridgeRequestModel: Codable {
    let fridgeName, fridgeComment: String
    let members: [Int]
    let newOwnerIdx: Int?
}
