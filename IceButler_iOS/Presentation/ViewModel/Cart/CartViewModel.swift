//
//  CartViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    static let shared = CartViewModel()
    
    private let cartService = CartService()
    
    @Published var cart: [CartFood]? = []
    @Published var cartFoods: [CartResponseModel] = []
    @Published var categoryTitles: [String] = []
    @Published var removeFoodIdxes: [Int]? = []
    @Published var isLongGesture = false
    
    private var cartCancelLabels: Set<AnyCancellable> = []
    private var removeCancelLabels: Set<AnyCancellable> = []
    private var longGestureCancellabels: Set<AnyCancellable> = []
    
    
    func cart(completion: @escaping ([CartFood]?) -> Void) {
        $cart.sink { cart in
            if cart != nil {
                completion(cart)
            }
        }.store(in: &cartCancelLabels)
    }
    
    func getFood(index: Int, completion: @escaping (CartFood) -> Void) {
        $cart.filter({ food in
            index < food!.count
        }).sink { cart in
            if cart?[index] != nil {
                completion((cart?[index])!)
            }
        }.store(in: &cartCancelLabels)
    }
    
    func getFoodName(index: Int, store: inout Set<AnyCancellable> ,completion: @escaping (String) -> Void) {
        $cart.filter { food in
            index < food!.count
        }.sink { food in
            completion((food?[index].foodName)!)
        }.store(in: &store)
    }
    
    func getFoodIdx(index: Int, store: inout Set<AnyCancellable>, completion: @escaping (Int) -> Void) {
        $cart.filter { food in
            index < food!.count
        }.sink { food in
            completion((food?[index].foodIdx)!)
        }.store(in: &store)
    }
    
    func getCategoryTitleWithIndex(index: Int) -> String {
        if self.categoryTitles.count > index { return self.categoryTitles[index] }
        else { return "알 수 없음" }
    }
    
    func getCartCetegoryCount() -> Int { return self.categoryTitles.count }
    func getCartFoodsWithCategory(index: Int) -> [CartFood] { return cartFoods[index].cartFoods }
    
    func setIsLongGesture(longGesture: Bool) {
        isLongGesture = longGesture
    }
    
    func getIsLongGesture(completion: @escaping (Bool) -> Void) {
        $isLongGesture.sink { isLongGesture in
            completion(isLongGesture)
        }.store(in: &longGestureCancellabels)
    }
    
    func isRemoveFoodIdxes(completion: @escaping (Bool) -> Void) {
        $removeFoodIdxes.sink { removeFoodIdxes in
            if removeFoodIdxes?.count != 0 {
                completion(true)
            }else {
                completion(false)
            }
        }.store(in: &removeCancelLabels)
    }
    
    func addRemoveIdx(removeIdx: Int) {
        removeFoodIdxes?.append(removeIdx)
    }
    
    func removeRemoveIdx(removeIdx: Int) {
        if let removeIndex = removeFoodIdxes?.firstIndex(where: { removeIndex in
            removeIndex == removeIdx
        }) {
//            removeCancelLabels.removeAll()
            removeFoodIdxes?.remove(at: removeIndex)
        }
    }
    
    func getRemoveIdx(completion: @escaping ([Int]) -> Void) {
        $removeFoodIdxes.sink { removeIdx in
            completion(removeIdx ?? [])
        }.store(in: &removeCancelLabels)
    }
    
    
    
    
    func getCart(cartId: Int) {
        cart?.removeAll()
        cartService.getCartFoodList(cartId: cartId) { cart in
            cart?.cartFoods.forEach({ food in
                self.cart?.append(food)
            })
        }
    }
    
    func deleteFood(cartId: Int) {
        cartCancelLabels.removeAll()
        cartService.deleteCartFood(cartId: cartId, removeFoodIdxes: removeFoodIdxes ?? []) { cart in
            self.cart = cart?.cartFoods
            CartManager.shared.reloadFoodCV()
        }
        
    }

    func fetchData() {
//        APIManger.shared.getData(urlEndpointString: "/carts/\(cartIndex)/foods",
        APIManger.shared.getData(urlEndpointString: "/carts/1/foods",   // 1은 임시 fridgeIdx
                                 responseDataType: [CartResponseModel].self,
                                 requestDataType: [CartResponseModel].self,
                                 parameter: nil,
                                 completionHandler: { [weak self] response in
            // TODO: 장바구니 식품 조회 결과 처리
            response.data?.forEach { self?.categoryTitles.append($0.category) }
            self?.cartFoods = response.data ?? []
        })
    }
    
    func getCategories(completion: @escaping ([String]) -> Void) {
        $categoryTitles.sink { categoryTitles in
            completion(categoryTitles)
        }.store(in: &cartCancelLabels)
    }
    
    func getCartFoods(completion: @escaping ([CartResponseModel]) -> Void) {
        $cartFoods.sink { cartFoods in
            completion(cartFoods)
        }.store(in: &cartCancelLabels)
    }
}
