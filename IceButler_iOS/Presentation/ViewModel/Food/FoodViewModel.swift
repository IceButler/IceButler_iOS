//
//  FoodViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import Foundation
import Combine

class FoodViewModel: ObservableObject {
    static let shared = FoodViewModel()
    
    private let foodService = FoodService()
    
    @Published var food: FoodDetailResponseModel?
    
    var cancelLabels: Set<AnyCancellable> = []
    
    func food(completion: @escaping (FoodDetailResponseModel) -> Void) {
        $food.sink { food in
            if food != nil {
                completion(food!)
            }
        }.store(in: &cancelLabels)
    }
    
    func getFoodDetail(fridgeIdx: Int, foodIdx: Int) {
        foodService.getAllFood(fridgeIdx: fridgeIdx, foodIdx: foodIdx) { foodDetail in
            self.food = foodDetail
        }
    }
}
