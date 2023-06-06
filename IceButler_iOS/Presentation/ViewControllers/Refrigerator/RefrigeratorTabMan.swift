//
//  RefrigeratorTabMan.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import UIKit

enum Category: CaseIterable {
    case Meat
    case Fruit
    case Vegetable
    case Beverage
    case AquaticProducts
    case sideDish
    case Snack
    case Ingredient
    case Processedfood
    case ETC
}

extension Category {
    private var title: String {
        switch self {
        case .Meat:
            return "육류"
        case .Fruit:
            return "과일"
        case .Vegetable:
            return "채소"
        case .Beverage:
            return "음료"
        case .AquaticProducts:
            return "수산물"
        case .sideDish:
            return "반찬"
        case .Snack:
            return "간식"
        case .Ingredient:
            return "식재료"
        case .Processedfood:
            return "가공식품"
        case .ETC:
            return "기타"
        }
    }
    
    func getTitle() -> String {
        return self.title
    }
}

class RefrigeratorTabMan: UIView {
    

}
