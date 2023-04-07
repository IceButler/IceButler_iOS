//
//  CartManager.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/03.
//

import Foundation
import UIKit

class CartManager {
    static let shared = CartManager()
    
    var cartIndex: String?
    
    var cartViewController: CartViewController? = nil
    var alertViewController: AlertViewController? = nil
    var cartMainTV: CartMainTableViewCell? = nil
    
    
    
    func setCartVC(cartVC: CartViewController) {
        cartViewController = cartVC
    }
    
    func setAlertVC(alertVC: AlertViewController) {
        alertViewController = alertVC
    }
    
    func setCartMainTV(cartTV: CartMainTableViewCell) {
        cartMainTV = cartTV
    }
    
    
    func showCartCVTabBar() {
        cartViewController?.showTabBar()
    }
    
    func reloadFoodCV() {
        cartMainTV?.reloadCV()
    }
    
    func fetchData() {
        APIManger.shared.getData(urlEndpointString: "/carts/\(cartIndex)/foods",
                                 responseDataType: GeneralResponseModel<CartResponseModel>.self,
                                 requestDataType: GeneralResponseModel<CartResponseModel>.self,
                                 parameter: nil,
                                 completionHandler: { _ in
            // TODO: 장바구니 식품 조회 결과 처리
        })
    }
}
