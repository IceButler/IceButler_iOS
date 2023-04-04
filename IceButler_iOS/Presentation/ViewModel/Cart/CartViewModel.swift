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
    
    @Published var cart: [Food]? = []
    @Published var removeFoodIdxes: [Int]? = []
    @Published var isLongGesture = false
    
    private var cartCancelLabels: Set<AnyCancellable> = []
    private var removeCancelLabels: Set<AnyCancellable> = []
    private var longGestureCancellabels: Set<AnyCancellable> = []
    
    
    func cart(completion: @escaping ([Food]?) -> Void) {
        $cart.sink { cart in
            if cart != nil {
                completion(cart)
            }
        }.store(in: &cartCancelLabels)
    }
    
    func getFood(index: Int, completion: @escaping (Food) -> Void) {
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
    
    func getCartCount() -> Int {
        return cart!.count
    }
    
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
            cart?.foods.forEach({ food in
                self.cart?.append(food)
            })
        }
    }
    
    func deleteFood(cartId: Int) {
        cartCancelLabels.removeAll()
        cartService.deleteCartFood(cartId: cartId, removeFoodIdxes: removeFoodIdxes ?? []) { cart in
            self.cart = cart?.foods
            CartManager.shared.reloadFoodCV()
        }
        
    }

}
