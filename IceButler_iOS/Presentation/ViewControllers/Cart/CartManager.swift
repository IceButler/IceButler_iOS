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
    
    var cartViewController: CartViewController? = nil
    var alertViewController: AlertViewController? = nil
    var foodCollectionView: UICollectionView? = nil
    
    
    func setCartVC(cartVC: CartViewController) {
        cartViewController = cartVC
    }
    
    func setAlertVC(alertVC: AlertViewController) {
        alertViewController = alertVC
    }
    
    func setFoodCV(foodCV: UICollectionView) {
        foodCollectionView = foodCV
    }
    
    
    func showCartCVTabBar() {
        cartViewController?.showTabBar()
    }
    
    func reloadFoodCV() {
        CartViewModel.shared.getCart(cartId: 1)
        foodCollectionView?.reloadData()
    }
}
