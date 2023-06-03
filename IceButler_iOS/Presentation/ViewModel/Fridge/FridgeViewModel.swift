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
    @Published var fridgeDiscard: FridgeDiscard?

    
    var searchMemberResults: [FridgeUser] = []
    
    var cancelLabels: Set<AnyCancellable> = []
    
    var defaultFridgeName: String = "냉장고 미선택"
    
    var currentFridgeName: String = ""
    
    func fridgeDiscard(completion: @escaping (FridgeDiscard?) -> Void) {
        $fridgeDiscard.sink { frdigeDiscard in
            completion(frdigeDiscard)
        }.store(in: &cancelLabels)
    }
    
    func allFoodList(foodListIdx: Int, completion: @escaping ([FridgeFood])-> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.filter({ allFoodList in
                allFoodList.count != 0
            }).sink { allFoodList in
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
    
    func isNoFoodList(foodListIdx: Int, completion: @escaping ()-> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 1:
            $meatFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 2:
            $fruitFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 3:
            $vegetableFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 4:
            $drinkFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 5:
            $marineProductsFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 6:
            $sideFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 7:
            $snackFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 8:
            $seasoningFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 9:
            $processedFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 10:
            $etcFoodList.filter({ allFoodList in
                allFoodList.count == 0
            }).sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        default:
            break
        }
    }
    
    func isChangeAllFoodList(foodListIdx: Int, completion: @escaping () -> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 1:
            $meatFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 2:
            $fruitFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 3:
            $vegetableFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 4:
            $drinkFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 5:
            $marineProductsFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 6:
            $sideFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 7:
            $snackFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 8:
            $seasoningFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 9:
            $processedFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
                completion()
            }.store(in: &cancelLabels)
            break
        case 10:
            $etcFoodList.filter { allFoodList in
                allFoodList.count > 0
            }.sink { allFoodList in
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
            $allFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 1:
            $meatFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 2:
            $fruitFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 3:
            $vegetableFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 4:
            $drinkFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 5:
            $marineProductsFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 6:
            $sideFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 7:
            $snackFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 8:
            $seasoningFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 9:
            $processedFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        case 10:
            $etcFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodName)
            }.store(in: &store)
            break
        default:
            break
        }
    }
    
    func allFoodListFoodDday(foodListIdx: Int, index: Int, store: inout Set<AnyCancellable>, completion: @escaping (Int)-> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 1:
            $meatFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 2:
            $fruitFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 3:
            $vegetableFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 4:
            $drinkFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 5:
            $marineProductsFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 6:
            $sideFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 7:
            $snackFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 8:
            $seasoningFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 9:
            $processedFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        case 10:
            $etcFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].shelfLife)
            }.store(in: &store)
            break
        default:
            break
        }
    }
    
    func allFoodListFoodImage(foodListIdx:Int, index: Int, store: inout Set<AnyCancellable>, completion: @escaping (String)-> Void) {
        switch foodListIdx {
        case 0:
            $allFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 1:
            $meatFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 2:
            $fruitFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 3:
            $vegetableFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 4:
            $drinkFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 5:
            $marineProductsFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 6:
            $sideFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 7:
            $snackFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 8:
            $seasoningFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 9:
            $processedFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
            break
        case 10:
            $etcFoodList.filter { allFoodList in
                allFoodList.count > index
            }.sink { allFoodList in
                completion(allFoodList[index].foodImgUrl)
            }.store(in: &store)
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
            self.fridgeDiscard = response?.fridgeDiscard
            response?.foodList.forEach({ food in
                self.allFoodList.append(food)
            })
        }
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.Meat.rawValue) { response in
            self.meatFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.meatFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.Fruit.rawValue) { response in
            self.fruitFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.fruitFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.Vegetable.rawValue) { response in
            self.vegetableFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.vegetableFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.Drink.rawValue) { response in
            self.drinkFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.drinkFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.MarineProducts.rawValue) { response in
            self.marineProductsFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.marineProductsFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.Side.rawValue) { response in
            self.sideFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.sideFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.Snack.rawValue) { response in
            self.snackFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.snackFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.Seasoning.rawValue) { response in
            self.seasoningFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.seasoningFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.ProcessedFood.rawValue) { response in
            self.processedFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.processedFoodList.append(food)
            })
        }
        
        fridgeService.getCategoryFood(fridgeIdx: fridgeIdx, category: FoodCategory.ETC.rawValue) { response in
            self.etcFoodList.removeAll()
            response?.foodList.forEach({ food in
                self.etcFoodList.append(food)
            })
        }
        
    }
    

}
extension FridgeViewModel {

    
    func setDefaultFridge() {
        APIManger.shared.getData(urlEndpointString: "/fridges",
                                 responseDataType: MyFridgeResponseModel.self,
                                 requestDataType: MyFridgeResponseModel.self,
                                 parameter: nil) { [weak self] response in
            
            switch response.statusCode {
            case 200:
                /// 최초 로딩에 보여질 냉장고 기본값 설정
                if response.data?.fridgeList?.count ?? 0 > 0 {
                    APIManger.shared.setFridgeIdx(index: (response.data?.fridgeList![0].fridgeIdx)!)
                    APIManger.shared.setIsMultiFridge(isMulti: false)
                    self?.defaultFridgeName = (response.data?.fridgeList![0].fridgeName)!
                    
                } else if response.data?.multiFridgeResList?.count ?? 0 > 0 {
                    APIManger.shared.setFridgeIdx(index: (response.data?.multiFridgeResList![0].multiFridgeIdx)!)
                    APIManger.shared.setIsMultiFridge(isMulti: true)
                    self?.defaultFridgeName = (response.data?.multiFridgeResList![0].multiFridgeName)!
                }
                print("default fridge idx --> \(APIManger.shared.getFridgeIdx())")
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
                
            default: return
            }
        }
    }
    
    func searchMember(nickname: String, completion: @escaping () -> Void) {
        fridgeService.getMemberSearchResults(nickname: nickname, completion: { [weak self] data in
            if let data = data {
                self?.searchMemberResults = data
                completion()
            }
        })
    }
    
    func requestAddFridge(isMulti: Bool, name: String, comment: String, members: [Int], completion: @escaping ((Bool)->Void)) {
        fridgeService.addFridge(isMulti: isMulti, name: name, comment: comment, members: members, completion: { response in
            if let fridgeId = response {
                APIManger.shared.setFridgeIdx(index: fridgeId)
            }
            completion((response != nil) ? true : false)
        })
    }
        
        /// 이전에 선택된 냉장고가 있다면 해당 냉장고로 기본 설정
    func setSavedFridgeIdx() {

        if let idx = UserDefaults.standard.value(forKey: "selectedFridgeIdx"),
           let name = UserDefaults.standard.value(forKey: "selectedFridgeName"),
           let isMulti = UserDefaults.standard.value(forKey: "selectedFridgeIsMulti"){
            APIManger.shared.setFridgeIdx(index: idx as! Int)
            APIManger.shared.setIsMultiFridge(isMulti: isMulti as! Bool)
            self.defaultFridgeName = name as! String
            print("현재 냉장고 Idx : \(idx as! Int) | 공용여부 : \(isMulti as! Bool)")
        }
    }

}
