//
//  FoodItem.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import Foundation

// MARK: - FoodItem
struct FoodItem: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let category: FoodCategory
    let expiryDate: Date
    let storageType: StorageType
    var isSelected: Bool
    
    init(id: UUID = UUID(), name: String, category: FoodCategory, expiryDate: Date, storageType: StorageType, isSelected: Bool = true) {
        self.id = id
        self.name = name
        self.category = category
        self.expiryDate = expiryDate
        self.storageType = storageType
        self.isSelected = isSelected
    }
    
    var expiryStatus: ExpiryStatus {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expiry = calendar.startOfDay(for: expiryDate)
        
        let daysDifference = calendar.dateComponents([.day], from: today, to: expiry).day ?? 0
        
        if daysDifference < 0 {
            return .expired
        } else if daysDifference <= 3 {
            return .expiringSoon
        } else {
            return .fresh
        }
    }
}

// MARK: - ExpiryStatus
enum ExpiryStatus: String, CaseIterable {
    case expired = "expired"
    case expiringSoon = "expiring_soon"
    case fresh = "fresh"
    
    var displayName: String {
        switch self {
        case .expired:
            return "만료됨"
        case .expiringSoon:
            return "임박"
        case .fresh:
            return "신선"
        }
    }
    
    var color: String {
        switch self {
        case .expired:
            return "systemRed"
        case .expiringSoon:
            return "systemOrange"
        case .fresh:
            return "systemGreen"
        }
    }
}

// MARK: - StorageType
enum StorageType: String, CaseIterable, Codable {
    case refrigerator = "refrigerator"
    case freezer = "freezer"
    case pantry = "pantry"
    
    var displayName: String {
        switch self {
        case .refrigerator:
            return "냉장"
        case .freezer:
            return "냉동"
        case .pantry:
            return "실온"
        }
    }
}

// MARK: - SubscriptionTier
enum SubscriptionTier: String, CaseIterable {
    case free = "free"
    case pro = "pro"
    case premium = "premium"
    
    var displayName: String {
        switch self {
        case .free:
            return "Free"
        case .pro:
            return "Pro"
        case .premium:
            return "Premium"
        }
    }
    
    var monthlyScans: Int {
        switch self {
        case .free:
            return 5
        case .pro:
            return 20
        case .premium:
            return -1 // Unlimited
        }
    }
    
    var price: String {
        switch self {
        case .free:
            return "무료"
        case .pro:
            return "$4.99/월"
        case .premium:
            return "$9.99/월"
        }
    }
}