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
    @Published var meatFoodList: [FridgeFood] = []
    @Published var fruitFoodList: [FridgeFood] = []
    @Published var vegetableFoodList: [FridgeFood] = []
    @Published var drinkFoodList: [FridgeFood] = []
    @Published var marineProductsFoodList: [FridgeFood] = []
    @Published var sideFoodList: [FridgeFood] = []
    @Published var snackFoodList: [FridgeFood] = []
    @Published var seasoningFoodList: [FridgeFood] = []
    @Published var processedFoodList: [FridgeFood] = []
    @Published var etcFoodList: [FridgeFood] = []
    
    var cancelLabels: Set<AnyCancellable> = []
    
    func allFoodList(foodListIdx: Int, completion: @escaping ([FridgeFood])-> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 1:
            $meatFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 2:
            $fruitFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 3:
            $vegetableFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 4:
            $drinkFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 5:
            $marineProductsFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 6:
            $sideFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 7:
            $snackFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 8:
            $seasoningFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 9:
            $processedFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        case 10:
            $etcFoodList.sink { allFoodList in
                completion(allFoodList)
            }.store(in: &cancelLabels)
            break
        default:
            break
        }
    }
    
    func isChangeAllFoodList(foodListIdx: Int, completion: @escaping () -> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 1:
            $meatFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 2:
            $fruitFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 3:
            $vegetableFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 4:
            $drinkFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 5:
            $marineProductsFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 6:
            $sideFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 7:
            $snackFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 8:
            $seasoningFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 9:
            $processedFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 10:
            $etcFoodList.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        default:
            break
        }
    }
    
    func allFoodListFoodName(foodListIdx:Int, index: Int, store: inout Set<AnyCancellable>, completion: @escaping (String)-> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 1:
            $meatFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 2:
            $fruitFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 3:
            $vegetableFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 4:
            $drinkFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 5:
            $marineProductsFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 6:
            $sideFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 7:
            $snackFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 8:
            $seasoningFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 9:
            $processedFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        case 10:
            $etcFoodList.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &cancelLabels)
            break
        default:
            break
        }
    }
    
    func allFoodListFoodDday(foodListIdx: Int, index: Int, store: inout Set<AnyCancellable>, completion: @escaping (String)-> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 1:
            $meatFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 2:
            $fruitFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 3:
            $vegetableFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 4:
            $drinkFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 5:
            $marineProductsFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 6:
            $sideFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 7:
            $snackFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 8:
            $seasoningFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 9:
            $processedFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        case 10:
            $etcFoodList.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &cancelLabels)
            break
        default:
            break
        }
    }
    
    func allFoodListCount(foodListIdx: Int) -> Int {
        switch foodListIdx {
        case 0:
            return allFoodList.count
        case 1:
            return meatFoodList.count
        case 2:
            return fruitFoodList.count
        case 3:
            return vegetableFoodList.count
        case 4:
            return drinkFoodList.count
        case 5:
            return marineProductsFoodList.count
        case 6:
            return sideFoodList.count
        case 7:
            return snackFoodList.count
        case 8:
            return seasoningFoodList.count
        case 9:
            return processedFoodList.count
        case 10:
            return etcFoodList.count
        default:
            return 0
        }
    }
    
    func foodIdx(foodListIdx: Int, index: Int) -> Int {
        switch foodListIdx {
        case 0:
            return allFoodList[index].fridgeFoodIdx
        case 1:
            return meatFoodList[index].fridgeFoodIdx
        case 2:
            return fruitFoodList[index].fridgeFoodIdx
        case 3:
            return vegetableFoodList[index].fridgeFoodIdx
        case 4:
            return drinkFoodList[index].fridgeFoodIdx
        case 5:
            return marineProductsFoodList[index].fridgeFoodIdx
        case 6:
            return sideFoodList[index].fridgeFoodIdx
        case 7:
            return snackFoodList[index].fridgeFoodIdx
        case 8:
            return seasoningFoodList[index].fridgeFoodIdx
        case 9:
            return processedFoodList[index].fridgeFoodIdx
        case 10:
            return etcFoodList[index].fridgeFoodIdx
        default:
            return 0
        }
    }
    
    func getAllFoodList(fridgeIdx: Int) {
        fridgeService.getAllFood(fridgeIdx: fridgeIdx) { response in
            self.allFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.allFoodList.append(food)
            })
        }
    }
    
    func getCategorFoodList(fridgeIdx: Int) {
        var foodLists = [meatFoodList, fruitFoodList, vegetableFoodList, drinkFoodList, marineProductsFoodList, sideFoodList, snackFoodList, seasoningFoodList, processedFoodList, etcFoodList]
        
        for i in 0..<foodLists.count {
            fridgeService.getCategoryFood(fridgeIdx: 1, category: FoodCategory.allCases[i].rawValue) { response in
                foodLists[i].removeAll()
                response?.foodList.forEach({ food in
                    foodLists[i].append(food)
                })
            }
        }
    }
}
