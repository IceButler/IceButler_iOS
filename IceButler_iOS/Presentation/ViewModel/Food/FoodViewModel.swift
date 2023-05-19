//
//  FoodViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import Foundation
import Combine
import UIKit
import Alamofire

class FoodViewModel: ObservableObject {
    static let shared = FoodViewModel()
    
    private let foodService = FoodService()
    
    @Published var food: FoodDetailResponseModel?
    @Published var foodOwnerList: [FoodOwner] = []
    @Published var barcodeFoodInfo: BarcodeFoodResponse?
    @Published var gptFoodNames: [String] = []
    @Published var gptFoodCategories: [String] = []
    @Published var searchFoodList: [SearchFoodResponse] = []
    @Published var selectedSearchFood: SearchFoodResponse?
    @Published var isEditFood: Bool = false
    @Published var fridgeSearchFoodList: [FridgeSearchFoodResponse] = []
    @Published var selectedFridgeSearchFood: FridgeSearchFoodResponse?
    
    var cancelLabels: Set<AnyCancellable> = []
    private var profileImgKey: String?
    
    func food(completion: @escaping (FoodDetailResponseModel) -> Void) {
        $food.sink { food in
            if food != nil {
                completion(food!)
            }
        }.store(in: &cancelLabels)
    }
    
    func getFood(completion: @escaping (FoodDetailResponseModel) -> Void) {
        completion(food!)
    }
    
    
    func foodImage(completion: @escaping (String) -> Void) {
        $food.filter({ food in
            food?.imgURL != nil
        }).sink { food in
            completion((food?.imgURL)!)
        }.store(in: &cancelLabels)
    }
    
    
    func barcodeFood(completion: @escaping (BarcodeFoodResponse?) -> Void) {
        $barcodeFoodInfo.sink { barcodeFood in
            completion(barcodeFood ?? nil)
        }.store(in: &cancelLabels)
    }
    
    func foodOwnerList(completion: @escaping () -> Void) {
        $foodOwnerList.sink { foodOwnerList in
            completion()
        }.store(in: &cancelLabels)
    }
    
    func foodOwnerListCount() -> Int {
        return foodOwnerList.count
    }
    
    func foodOwnerListName(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $foodOwnerList.filter { foodOwnerList in
            index < foodOwnerList.count
        }.sink { foodOwnerList in
            completion((foodOwnerList[index].nickName) ?? "")
        }.store(in: &store)
    }
    
    func foodOwnerListName(index: Int) -> String {
        guard let nickname = foodOwnerList[index].nickName else {return ""}
        return nickname
    }
    
    func foodOwnerListIdx(index:Int) -> Int {
        return foodOwnerList[index].userIdx
    }
    
    func foodOwnerListImage(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $foodOwnerList.filter { foodOwnerList in
            index < foodOwnerList.count
        }.sink { foodOwnerList in
            completion((foodOwnerList[index].profileImage)!)
        }.store(in: &store)
    }
    
    func gptFoodNames(index: Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $gptFoodNames.filter({ gptFoodNames in
            index < gptFoodNames.count && gptFoodNames.count != 0
        }).sink { gptFoodNames in
            completion(gptFoodNames[index])
        }.store(in: &store)
    }
    
    func getGptFoodName(index: Int) -> String {
        return gptFoodNames[index]
    }
    
    func isChangeGptFoodNames(completion: @escaping () -> Void) {
        $gptFoodNames.filter({ gptFoodNames in
            gptFoodNames.count > 0
        }).sink { gptFoodNames in
            completion()
        }.store(in: &cancelLabels)
    }
    
    func gptFoodNamesCount() -> Int {
        return gptFoodNames.count
    }
    
    func gptFoodCategory(index: Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $gptFoodCategories.filter({ gptFoodCategories in
            index < gptFoodCategories.count && gptFoodCategories.count != 0
        }).sink { gptFoodCategories in
            completion(gptFoodCategories[index])
        }.store(in: &store)
    }
    
    func gptFoodCategoriesCount() -> Int {
        return gptFoodCategories.count
    }
    
    func getGptFoodCategory(index: Int) -> String {
        return gptFoodCategories[index]
    }
    
    func isChangeFoodCategories(completion: @escaping () -> Void) {
        $gptFoodCategories.filter({ gptFoodCategories in
            gptFoodCategories.count > 0
        }).sink { gptFoodCategories in
            completion()
        }.store(in: &cancelLabels)
    }

    func isSearchFoodList(completion: @escaping (Bool) -> Void) {
        $searchFoodList.sink { searchFoodList in
            if searchFoodList.count == 0 {
                completion(false)
            }else{
                completion(true)
            }
        }.store(in: &cancelLabels)
    }
    
    func searchFoodIdx(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (Int) -> Void) {
        $searchFoodList.filter { searchFoodList in
            index < searchFoodList.count && searchFoodList.count != 0
        }.sink { searchFoodList in
            completion(searchFoodList[index].foodIdx)
        }.store(in: &cancelLabels)
    }
    
    func searchFoodName(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $searchFoodList.filter { searchFoodList in
            index < searchFoodList.count && searchFoodList.count != 0
        }.sink { searchFoodList in
            completion(searchFoodList[index].foodName)
        }.store(in: &cancelLabels)
    }
    
    func searchFoodImg(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $searchFoodList.filter { searchFoodList in
            index < searchFoodList.count && searchFoodList.count != 0
        }.sink { searchFoodList in
            completion(searchFoodList[index].foodImgUrl)
        }.store(in: &cancelLabels)
    }
    
    func searchFoodListCount() -> Int {
        return searchFoodList.count
    }
    
    func selectedSearchFood(completion: @escaping (SearchFoodResponse) -> Void) {
        $selectedSearchFood.filter { selectedSearchFood in
            selectedSearchFood != nil
        }.sink { selectedSearchFood in
            completion(selectedSearchFood!)
        }.store(in: &cancelLabels)
    }
    
    
    func isFridgeSearchFoodList(completion: @escaping (Bool) -> Void) {
        $fridgeSearchFoodList.sink { fridgeSearchFoodList in
            if fridgeSearchFoodList.count == 0 {
                completion(false)
            }else{
                completion(true)
            }
        }.store(in: &cancelLabels)
    }
    
    func fridgeSearchFoodIdx(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (Int) -> Void) {
        $fridgeSearchFoodList.filter { fridgeSearchFoodList in
            index < fridgeSearchFoodList.count && fridgeSearchFoodList.count != 0
        }.sink { fridgeSearchFoodList in
            completion(fridgeSearchFoodList[index].fridgeFoodIdx)
        }.store(in: &cancelLabels)
    }
    
    func fridgeSearchFoodName(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $fridgeSearchFoodList.filter { fridgeSearchFoodList in
            index < fridgeSearchFoodList.count && fridgeSearchFoodList.count != 0
        }.sink { fridgeSearchFoodList in
            completion(fridgeSearchFoodList[index].foodName)
        }.store(in: &cancelLabels)
    }
    
    func fridgeSearchFoodImg(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $fridgeSearchFoodList.filter { fridgeSearchFoodList in
            index < fridgeSearchFoodList.count && fridgeSearchFoodList.count != 0
        }.sink { fridgeSearchFoodList in
            completion(fridgeSearchFoodList[index].foodImgUrl)
        }.store(in: &cancelLabels)
    }
    
    func fridgeSearchFoodDay(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (Int) -> Void) {
        $fridgeSearchFoodList.filter { fridgeSearchFoodList in
            index < fridgeSearchFoodList.count && fridgeSearchFoodList.count != 0
        }.sink { fridgeSearchFoodList in
            completion(fridgeSearchFoodList[index].shelfLife)
        }.store(in: &cancelLabels)
    }
    
    func fridgeSearchFoodListCount() -> Int {
        return fridgeSearchFoodList.count
    }
    
    func selectedFridgeSearchFood(completion: @escaping (FridgeSearchFoodResponse) -> Void) {
        $selectedFridgeSearchFood.filter { selectedFridgeSearchFood in
            selectedFridgeSearchFood != nil
        }.sink { selectedFridgeSearchFood in
            completion(selectedFridgeSearchFood!)
        }.store(in: &cancelLabels)
    }
    
    
    func isEditFood(completion: @escaping (Bool) -> Void) {
        $isEditFood.sink { isEditFood in
            completion(isEditFood)
        }.store(in: &cancelLabels)
    }
    
    
    func findFoodOwnerIdx(name: String) -> Int {
        for i in 0..<foodOwnerList.count {
            if foodOwnerList[i].nickName == name {
                return foodOwnerList[i].userIdx
            }
        }
        return 0
    }
    
    
    func deleteAll() {
        self.food = nil
        self.foodOwnerList = []
        self.barcodeFoodInfo = nil
        self.gptFoodNames = []
        self.gptFoodCategories = []
        self.selectedSearchFood = nil
        self.searchFoodList = []
        self.isEditFood = false
        self.selectedFridgeSearchFood = nil
        self.fridgeSearchFoodList = []
    }
}





extension FoodViewModel {
    func getFoodDetail(foodIdx: Int) {
        foodService.getAllFood(foodIdx: foodIdx) { foodDetail in
            self.food = foodDetail
        }
    }

    
    func getFoodOwnerList(fridgeIdx: Int) {
        foodService.getFoodOwnerList() { foodOwnerList in
            self.foodOwnerList.removeAll()
            foodOwnerList?.fridgeUsers.forEach({ foodOwner in
                self.foodOwnerList.append(foodOwner)
            })
        }
    }
    
    func getBarcodeFood(barcode: String) {
        foodService.getBarcodeFood(barcode: barcode) { barcodeFood in
            self.barcodeFoodInfo = barcodeFood
            if let foodDetailName = barcodeFood.foodDetailName {
                self.getGptFood(foodDetailName: foodDetailName)
            }
        }
    }
    
    
    func getUploadImageUrl(imageDir: ImageDir, image: UIImage, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int, memo: String?, completion: @escaping (Bool) -> Void) {
        let parameter: Parameters = ["ext": "jpeg", "dir": imageDir.rawValue]
        ImageService.shared.getImageUrl(parameter: parameter) {[self] response in
            if let response = response {
                profileImgKey = response.imageKey
                uploadProfileImage(image: image, url: response.presignedUrl, fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, completion: completion)
            }
        }
    }
    
    func getUploadImageUrl(foodIdx: Int, imageDir: ImageDir, image: UIImage, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int, memo: String?, completion: @escaping (Bool) -> Void) {
        let parameter: Parameters = ["ext": "jpeg", "dir": imageDir.rawValue]
        ImageService.shared.getImageUrl(parameter: parameter) {[self] response in
            if let response = response {
                profileImgKey = response.imageKey
                uploadProfileImage(image: image, url: response.presignedUrl, fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, completion: completion)
            }
        }
    }
    
    func uploadProfileImage(image: UIImage, url: String, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int, memo: String?, completion: @escaping (Bool) -> Void) {
        ImageService.shared.uploadImage(image: image, url: url) {
            self.postFood(fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, imgUrl: self.profileImgKey, completion: completion)
        }
    }
    
    func uploadProfileImage(foodIdx: Int, image: UIImage, url: String, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int, memo: String?, completion: @escaping (Bool) -> Void) {
        ImageService.shared.uploadImage(image: image, url: url) {
            self.postFood(fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, imgUrl: self.profileImgKey, completion: completion)
        }
    }
    
    func patchFood(foodIdx: Int, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int, memo: String?, imgUrl: String?, completion: @escaping (Bool) -> Void) {
        let foodAddModel: FoodAddRequestModel = FoodAddRequestModel(foodName: foodName, foodDetailName: foodDetail, foodCategory: foodCategory, shelfLife: foodShelfLife, memo: memo, imageUrl: imgUrl, ownerIdx: foodOwnerIdx)
        
        
        foodService.patchFood(foodIdx: foodIdx, parameter: foodAddModel) { result in
            if result {
                FoodViewModel.shared.getFoodDetail(foodIdx: foodIdx)
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: fridgeIdx)
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    
    func postFood(fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int, memo: String?, imgUrl: String?, completion: @escaping (Bool) -> Void) {
        var foodAddModel: [FoodAddRequestModel] = []
        foodAddModel.append(FoodAddRequestModel(foodName: foodName, foodDetailName: foodDetail, foodCategory: foodCategory, shelfLife: foodShelfLife, memo: memo, imageUrl: imgUrl, ownerIdx: foodOwnerIdx))
        
        let parameter = FoodAddListModel(fridgeFoods: foodAddModel)
        
        foodService.postFood(parameter: parameter) { result in
            if result {
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: fridgeIdx)
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func getGptFood(foodDetailName: String) {
        DispatchQueue.global().async {
            self.foodService.getGptFoodName(foodDetailName: foodDetailName) { response in
                self.gptFoodNames = response.words
            }
            
            self.foodService.getGptFoodCategory(foodDetailName: foodDetailName) { response in
                self.gptFoodCategories = response.categories
            }
        }
    }
    
    func getSearchFood(word: String) {
        foodService.getSearchFood(word: word) { result in
            if let result = result {
                self.searchFoodList = result
            }
        }
    }
    
    func getFridgeSearchFood(word: String) {
        foodService.getFridgeSearchFood(word: word) { result in
            if let result = result {
                self.fridgeSearchFoodList = result
            }
        }
    }
    
    func selectSearchFood(index: Int) {
        selectedSearchFood = searchFoodList[index]
    }
    
    func selectFridgeSearchFood(index: Int) {
        selectedFridgeSearchFood = fridgeSearchFoodList[index]
        getFoodDetail(foodIdx: selectedFridgeSearchFood?.fridgeFoodIdx ?? 0)
    }
}
