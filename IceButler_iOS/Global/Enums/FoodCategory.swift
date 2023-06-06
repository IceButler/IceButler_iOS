//
//  FoodCategory.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import Foundation
import UIKit


enum FoodCategory: String, CaseIterable {
    case Meat = "육류"
    case Fruit = "과일"
    case Vegetable = "채소"
    case Drink = "음료"
    case MarineProducts = "수산물"
    case Side = "반찬"
    case Seasoning = "조미료"
    case ProcessedFood = "가공식품"
    case ETC = "기타"
}

extension FoodCategory {
    var color: UIColor{
        switch self {
        case .Meat:
            return UIColor(red: 0.976, green: 0.776, blue: 0.847, alpha: 1)
        case .Fruit:
            return UIColor(red: 0.988, green: 0.78, blue: 0.667, alpha: 1)
        case .Vegetable:
            return UIColor(red: 0.769, green: 0.91, blue: 0.663, alpha: 1)
        case .Drink:
            return UIColor(red: 1, green: 0.915, blue: 0.613, alpha: 1)
        case .MarineProducts:
            return UIColor(red: 0.655, green: 0.763, blue: 0.908, alpha: 1)
        case .Side:
            return UIColor(red: 1, green: 0.721, blue: 0.683, alpha: 1)
        case .Seasoning:
            return UIColor(red: 0.713, green: 0.817, blue: 0.892, alpha: 1)
        case .ProcessedFood:
            return UIColor(red: 0.808, green: 0.816, blue: 0.949, alpha: 1)
        case .ETC:
            return UIColor(red: 0.799, green: 0.908, blue: 0.869, alpha: 1)
        }
    }
}

