//
//  PolicyType.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/15.
//

import Foundation

enum PolicyType: String {
    case tosGuide = "약관 안내"
    case privacyPolicy = "개인정보 처리 방침"
}

enum PolicyUrl: String {
    case tosGuide = "https://sites.google.com/view/icebutler-tos"
    case privacyPolicy = "https://sites.google.com/view/icebutler-privacy-policy"
}
