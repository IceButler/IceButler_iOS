//
//  FridgeViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/09.
//

import Foundation
import Combine

class FridgeViewModel: ObservableObject {
    static let shared = FridgeViewModel()
    
    private let fridgeService = FridgeService()
    
    @Published var allFoodList: [FridgeFood] = []
    
    var cancelLabels: Set<AnyCancellable> = []
    
    func allFoodList(completion: @escaping ([FridgeFood])-> Void) {
        $allFoodList.sink { allFoodList in
            completion(allFoodList)
        }.store(in: &cancelLabels)
    }
    
    func allFoodListFoodName(index: Int, store: inout Set<AnyCancellable>, completion: @escaping (String)-> Void) {
        $allFoodList.sink { allFoodList in
            completion(allFoodList[index].foodName)
        }.store(in: &store)
    }
    
    func allFoodListFoodDday(index: Int, store: inout Set<AnyCancellable>, completion: @escaping (String)-> Void) {
        $allFoodList.sink { allFoodList in
            completion(allFoodList[index].shelfLife)
        }.store(in: &store)
    }
    
    func allFoodListCount() -> Int {
        return allFoodList.count
    }
    
    func getAllFoodList(fridgeIdx: Int) {
        fridgeService.getAllFood(fridgeIdx: fridgeIdx) { response in
            self.allFoodList.removeAll()
            response?.foodList.forEach({ food in
                print(food)
                self.allFoodList.append(food)
            })
        }
    }
}
