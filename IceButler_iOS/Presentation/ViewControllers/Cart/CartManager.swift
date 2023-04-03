//
//  CartManager.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/03.
//

import Foundation

enum Status {
    case done
    case processing
}

class CartManager {
    static let shared = CartManager()
    
    var status: Status = .processing
    var selectedRow: Int = -1
    var selectedIndex: Int = -1
    
    let categoryTitleArr = [ "육류", "과일", "채소", "음료", "수산물", "반찬", "간식", "식재료", "가공식품", "기타" ]
    
    // 임시 데이터
    var tempFoods = [
        "육류": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "과일": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "채소": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "음료": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "수산물": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "반찬": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "간식": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "식재료": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "가공식품": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
        "기타": ["당근", "오이", "호박", "감자", "멜론", "딸기", "사과", "바나나", "우유", "크로와상"],
    ]
    
    func deleteFood() {
        print("CartManager :: row - \(self.selectedRow) / index - \(self.selectedIndex)")
        self.tempFoods[categoryTitleArr[self.selectedRow]]?.remove(at: self.selectedIndex)
        print(tempFoods[categoryTitleArr[self.selectedRow]])
    }
}
