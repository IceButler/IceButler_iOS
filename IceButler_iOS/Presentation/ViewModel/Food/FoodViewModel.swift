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
    
    var cancelLabels: Set<AnyCancellable> = []
    private var profileImgKey: String?
    
    func food(completion: @escaping (FoodDetailResponseModel) -> Void) {
        $food.sink { food in
            if food != nil {
                completion(food!)
            }
        }.store(in: &cancelLabels)
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
        $foodOwnerList.sink { foodOwnerList in
            completion((foodOwnerList[index].nickname) ?? "")
        }.store(in: &store)
    }
    
    func foodOwnerListIdx(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (Int) -> Void) {
        $foodOwnerList.sink { foodOwnerList in
            completion(foodOwnerList[index].userIdx)
        }.store(in: &store)
    }
    
    func foodOwnerListImage(index:Int, store: inout Set<AnyCancellable>, completion: @escaping (String) -> Void) {
        $foodOwnerList.sink { foodOwnerList in
            completion((foodOwnerList[index].profileImage)!)
        }.store(in: &store)
    }
    
    func getFoodDetail(fridgeIdx: Int, foodIdx: Int) {
        foodService.getAllFood(fridgeIdx: fridgeIdx, foodIdx: foodIdx) { foodDetail in
            self.food = foodDetail
        }
    }

    
    func getFoodOwnerList(fridgeIdx: Int) {
        foodService.getFoodOwnerList(fridgeIdx: fridgeIdx) { foodOwnerList in
            self.foodOwnerList.removeAll()
            foodOwnerList?.userList.forEach({ foodOwner in
                self.foodOwnerList.append(foodOwner)
            })
        }
    }
    
    func getBarcodeFood(barcode: String) {
        foodService.getBarcodeFood(barcode: barcode) { barcodeFood in
            self.barcodeFoodInfo = barcodeFood
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
    
    func uploadProfileImage(image: UIImage, url: String, fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int, memo: String?, completion: @escaping (Bool) -> Void) {
        ImageService.shared.uploadImage(image: image, url: url) {
            self.postFood(fridgeIdx: fridgeIdx, foodName: foodName, foodDetail: foodDetail, foodCategory: foodCategory, foodShelfLife: foodShelfLife, foodOwnerIdx: foodOwnerIdx, memo: memo, imgUrl: self.profileImgKey, completion: completion)
        }
    }
    
    
    func postFood(fridgeIdx: Int, foodName: String, foodDetail: String, foodCategory: String, foodShelfLife: String, foodOwnerIdx: Int, memo: String?, imgUrl: String?, completion: @escaping (Bool) -> Void) {
        let parameter = FoodAddRequestModel(foodName: foodName, foodDetailName: foodDetail, foodCategory: foodCategory, shelfLife: foodShelfLife, memo: memo, imageUrl: imgUrl, ownerIdx: foodOwnerIdx)
        
        foodService.postFood(fridgeIdx: fridgeIdx, parameter: parameter) { result in
            if result {
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: fridgeIdx)
                completion(true)
            }else {
                completion(false)
            }
        }
    }
}
