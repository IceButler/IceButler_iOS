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
    
    private var cartCancelLabels: Set<AnyCancellable> = []
    private var removeCancelLabels: Set<AnyCancellable> = []
    
    
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
    
    func getCartCount() -> Int {
        return cart!.count
    }
    
    func isremoveFoodIdxes(completion: @escaping (Bool) -> Void) {
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
        guard let idx = removeFoodIdxes?.firstIndex(of: removeIdx) else { return }
        removeCancelLabels.removeAll()
        removeFoodIdxes?.remove(at: idx)
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
            cart?.foods.forEach({ food in
                self.cart?.append(food)
            })
            CartManager.shared.reloadFoodCV()
        }
        
    }

}
