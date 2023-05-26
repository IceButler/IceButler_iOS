//
//  NotificationResponseModel.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/25.
//

import Foundation

struct NotificationResponseModel: Codable {
    let content: [Notification]
    let pageable: PageableModel?
    let last, first, empty: Bool?
    let totalPage, totalElements, number, size, numberOfElements: Int?
    let sort: SortModel?
}

struct Notification: Codable {
    let pushNotificationType, notificationInfo: String?
    let createdAt: Date?
}

struct PageableModel: Codable {
    let sort: Sort?
    let offset, pageNumber, pageSize: Int?
    let paged, unpaged: Bool?
}

struct SortModel: Codable {
    let empty, sorted, unsorted: Bool?
}


// MARK: 서버로부터 가져온 데이터를 후처리 한 후의 모델
struct NotificationData {
    var createdAt: [String]
    var content: [[Notification]]
}
