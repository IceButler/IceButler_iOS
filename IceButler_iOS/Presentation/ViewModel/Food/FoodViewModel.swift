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
    @Published var isSelectedFood: Bool = false
    @Published var deleteFoodIdx: [Int] = []
    @Published var isFoodAddComplete = false
    
    var isFoodAddCompleteList = [false, false, false, false]
    
    var cancelLabels: Set<AnyCancellable> = []
    private var profileImgKey: String?
    
    var uploadedFoodImgUrl: String = "" // 테스트용
    
    func food(completion: @escaping (FoodDetailResponseModel) -> Void) {
        $food.sink { food in
            if food != nil {
                completion(food!)
            }
        }.store(in: &cancelLabels)
    }
    
    func getFood() -> FoodDetailResponseModel {
        return food!
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
            completion((foodOwnerList[index].profileImageUrl) ?? "")
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
    
    func isFoodAddCmplete(completion: @escaping (Bool) -> Void) {
        $isFoodAddComplete.sink { isFoodAddComplete in
            completion(isFoodAddComplete)
        }.store(in: &cancelLabels)
    }
    
    func deleteFoodIdx(completion: @escaping ([Int]) -> Void) {
        $deleteFoodIdx.sink { deleteFoodIdx in
            completion(deleteFoodIdx)
        }.store(in: &cancelLabels)
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
        self.isFoodAddComplete = false
        self.isFoodAddCompleteList = [false, false, false, false]
    }
    
    
    
    
    func isSelectedFood(completion: @escaping (Bool) -> Void) {
        $isSelectedFood.sink { isSelectedFood in
            completion(isSelectedFood)
        }.store(in: &cancelLabels)
    }
    
    func setIsSelectedFood(isSelected: Bool) {
        if isSelected == false {
            deleteFoodIdx.removeAll()
        }
        isSelectedFood = isSelected
    }
    
    
    func getIsSelectedFood()-> Bool {
        return isSelectedFood
    }
    
    func tapDeleteFoodIdx(foodIdx: Int) -> Bool {
        var index = -10
        
        for i in 0..<deleteFoodIdx.count {
            if deleteFoodIdx[i] == foodIdx {
                index = i
            }
        }
        
        if index == -10 {
            deleteFoodIdx.append(foodIdx)
            return true
        }else {
            deleteFoodIdx.remove(at: index)
            if deleteFoodIdx.count == 0 {
                isSelectedFood = false
            }
            return false
        }
    }
    
    
    
    func setIsFoodAddComplete(index: Int) {
        isFoodAddCompleteList[index] = true
        
        var result = true
        
        isFoodAddCompleteList.forEach { isFoodAddComplete in
            if isFoodAddComplete == false {
                result = false
            }
        }
        
        print(isFoodAddCompleteList)
        
        isFoodAddComplete = result
    }
}





extension FoodViewModel {
    func eatFoods(completion: @escaping (Bool) -> Void) {
        foodService.eatFoods(deleteFoods: deleteFoodIdx) { result in
            completion(result)
            if result {
                self.deleteFoodIdx.removeAll()
                self.isSelectedFood = false
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
            }
        }
    }
    
    func eatFoods(foodIdx: Int, completion: @escaping (Bool) -> Void) {
        deleteFoodIdx.append(foodIdx)
        foodService.eatFoods(deleteFoods: deleteFoodIdx) { result in
            completion(result)
            if result {
                self.deleteFoodIdx.removeAll()
                self.isSelectedFood = false
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
            }
        }
    }
    
    func deleteFoods(completion: @escaping (Bool) -> Void) {
        foodService.deleteFoods(deleteFoods: deleteFoodIdx) { result in
            completion(result)
            if result {
                self.deleteFoodIdx.removeAll()
                self.isSelectedFood = false
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
            }
        }
    }
    
    func deleteFoods(foodIdx: Int, completion: @escaping (Bool) -> Void) {
        deleteFoodIdx.append(foodIdx)
        foodService.deleteFoods(deleteFoods: deleteFoodIdx) { result in
            completion(result)
            if result {
                self.deleteFoodIdx.removeAll()
                self.isSelectedFood = false
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
            }
        }
    }
    
    
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
    
    
    func getUploadImageUrl(imageDir: ImageDir, image: UIImage, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int?, memo: String?, completion: @escaping (Bool) -> Void) {
        let parameter: Parameters = ["ext": "jpeg", "dir": imageDir.rawValue]
        ImageService.shared.getImageUrl(parameter: parameter) {[self] response in
            if let response = response {
                profileImgKey = response.imageKey
                uploadProfileImage(image: image, url: response.presignedUrl, fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, completion: completion)
            }
        }
    }
    
    func getUploadImageUrl(foodIdx: Int, imageDir: ImageDir, image: UIImage, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int?, memo: String?, completion: @escaping (Bool) -> Void) {
        let parameter: Parameters = ["ext": "jpeg", "dir": imageDir.rawValue]
        ImageService.shared.getImageUrl(parameter: parameter) {[self] response in
            if let response = response {
                profileImgKey = response.imageKey
                uploadProfileImage(image: image, url: response.presignedUrl, fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, completion: completion)
            }
        }
    }
    
    func uploadProfileImage(image: UIImage, url: String, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int?, memo: String?, completion: @escaping (Bool) -> Void) {
        ImageService.shared.uploadImage(image: image, url: url) {
            self.postFood(fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, imgUrl: self.profileImgKey, completion: completion)
        }
    }
    

    /// 장보기 완료 후 식품추가 요청에 필요한 이미지 업로드 요청 메소드
    func getUploadImageUrl(imageDir: ImageDir, image: UIImage, completion: @escaping (String) -> Void) {
        let parameter: Parameters = ["ext": "jpeg", "dir": imageDir.rawValue]
        ImageService.shared.getImageUrl(parameter: parameter) {[self] response in
            // uploadProfileImage 호출
            if let response = response {
                uploadProfileImage(image: image, url: response.presignedUrl)
                uploadedFoodImgUrl = response.presignedUrl
                completion(response.imageKey)
            }
        }
    }

    func uploadProfileImage(image: UIImage, url: String) {
        ImageService.shared.uploadImage(image: image, url: url) {
                // 이미지 업로드
            self.uploadedFoodImgUrl = ""
        }
    }

    func uploadProfileImage(foodIdx: Int, image: UIImage, url: String, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int?, memo: String?, completion: @escaping (Bool) -> Void) {
        ImageService.shared.uploadImage(image: image, url: url) {
            self.postFood(fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, imgUrl: self.profileImgKey, completion: completion)
        }
    }
    
    func patchFood(foodIdx: Int, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int?, memo: String?, imgUrl: String?, completion: @escaping (Bool) -> Void) {
        let foodAddModel: FoodAddRequestModel = FoodAddRequestModel(foodName: foodName, foodDetailName: foodDetail, foodCategory: foodCategory, shelfLife: foodShelfLife, memo: memo, imgKey: imgUrl, ownerIdx: foodOwnerIdx)
        
        
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
    
    
    func postFood(fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int?, memo: String?, imgUrl: String?, completion: @escaping (Bool) -> Void) {
        var foodAddModel: [FoodAddRequestModel] = []
        foodAddModel.append(FoodAddRequestModel(foodName: foodName, foodDetailName: foodDetail, foodCategory: foodCategory, shelfLife: foodShelfLife, memo: memo, imgKey: imgUrl, ownerIdx: foodOwnerIdx))
        
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
