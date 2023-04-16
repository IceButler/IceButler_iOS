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
    
    var cartFoodData: [String : [String]] = [:]
    
    func setCartVC(cartVC: CartViewController) { cartViewController = cartVC }
    func setAlertVC(alertVC: AlertViewController) { alertViewController = alertVC }
    func setCartMainTV(cartTV: CartMainTableViewCell) { cartMainTV = cartTV }
    
    func showCartCVTabBar() { cartViewController?.showTabBar() }
    func showCartVCAlertView() { cartViewController?.showAlertView() }
    
    func reloadFoodCV() { cartMainTV?.reloadCV() }
}
