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
    
//    @Published var cart: [CartFood]? = []
//    @Published var cartFoods: [CartResponseModel] = []
//    @Published var removeFoodIdxes: [Int]? = []
//    @Published var removeFoodNames: [String] = []
//    @Published var isLongGesture = false
    
    var cart: [CartFood]? = []
    var cartFoods: [CartResponseModel] = []
    var removeFoodIdxes: [Int]? = []
    var removeFoodNames: [String] = []
    var isLongGesture = false
    
    private var cartCancelLabels: Set<AnyCancellable> = []
    private var removeCancelLabels: Set<AnyCancellable> = []
    private var longGestureCancellabels: Set<AnyCancellable> = []
    
    
    /// CartManager의 변수 및 메소드
    var cartIndex: String?
    
    var cartViewController: CartViewController? = nil
    var alertViewController: AlertViewController? = nil
    var cartMainTV: CartMainTableViewCell? = nil
    
    var cartFoodData: [String : [String]] = [:]
    
    func setCartVC(cartVC: CartViewController) { cartViewController = cartVC }
    func setAlertVC(alertVC: AlertViewController) { alertViewController = alertVC }
    func setCartMainTV(cartTV: CartMainTableViewCell) { cartMainTV = cartTV }
    
    func showCartCVTabBar() { cartViewController?.showTabBar() }
    func showCartVCAlertView() { cartViewController?.showAlertView() }
    
    func reloadFoodCV() { cartMainTV?.reloadCV() }
    ///
    
//    func cart(completion: @escaping ([CartFood]?) -> Void) {
//        $cart.sink { cart in
//            if cart != nil {
//                completion(cart)
//            }
//        }.store(in: &cartCancelLabels)
//    }
//
//    func getFood(index: Int, completion: @escaping (CartFood) -> Void) {
//        $cart.filter({ food in
//            index < food!.count
//        }).sink { cart in
//            if cart?[index] != nil {
//                completion((cart?[index])!)
//            }
//        }.store(in: &cartCancelLabels)
//    }
//
//    func getFoodName(index: Int, store: inout Set<AnyCancellable> ,completion: @escaping (String) -> Void) {
//        $cart.filter { food in
//            index < food!.count
//        }.sink { food in
//            completion((food?[index].foodName)!)
//        }.store(in: &store)
//    }
//
//    func getFoodIdx(index: Int, store: inout Set<AnyCancellable>, completion: @escaping (Int) -> Void) {
//        $cart.filter { food in
//            index < food!.count
//        }.sink { food in
//            completion((food?[index].foodIdx)!)
//        }.store(in: &store)
//    }
    
    func getCategoryTitleWithIndex(index: Int) -> String {
        if self.cartFoods.count > index { return self.cartFoods[index].category }
        else { return "알 수 없음" }
    }
    
    func getCartFoodsWithCategory(index: Int) -> [CartFood] { return cartFoods[index].cartFoods }
    
    func setIsLongGesture(longGesture: Bool) { isLongGesture = longGesture }

    func addRemoveIdx(removeIdx: Int, removeName: String) {
        if removeIdx != -1 {
            removeFoodIdxes?.append(removeIdx)
            removeFoodNames.append(removeName)
        }
    }
    
    func removeRemoveIdx(removeIdx: Int) {
        if let removeIndex = removeFoodIdxes?.firstIndex(where: { removeIndex in
            removeIndex == removeIdx
        }) { removeFoodIdxes?.remove(at: removeIndex) }
    }

    func deleteFood(cartId: Int) {
        let param = CartRemoveRequestModel(foodIdxes: removeFoodIdxes ?? [])
        let fridgeIdx = APIManger.shared.getFridgeIdx()

        cartService.deleteCartFood(removeFoodIdxes: removeFoodIdxes ?? [],
                                          completion:{ [weak self] data in
            self?.cartViewController?.configure()
            self?.showCartCVTabBar()
        })
    }
    
    func addFoods(foods: [AddFood]) {
        cartService.postFoodsAdd(foods: foods)
    }

    func fetchData() {
        let fridgeId = APIManger.shared.getFridgeIdx()
        cartService.getCartFoodList(completion: { [weak self] response in
            self?.cartFoods = response ?? []
        })
    }
}
