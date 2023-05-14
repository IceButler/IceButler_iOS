//
//  KakaoMapDataModel.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/15.
//

import Foundation

struct KakaoMapDataModel: Codable {
    let documents: [KakaoStoreData]
    let meta: Meta
}

struct KakaoStoreData: Codable {
    let address_name: String?
    let category_group_code: String?
    let category_group_name: String?
    let category_name: String?
    let id: String?
    let phone: String?
    let place_url: String?
    let road_address_name: String?
    let x: String?
    let y: String?
}

struct Meta: Codable {
    let is_end: Bool?
    let pageable_count: Int?
    let same_name: SameName?
    let total_count: Int?
}

struct SameName: Codable {
    let region: [String]?
    let keyword: String?
    let selected_region: String?
}
