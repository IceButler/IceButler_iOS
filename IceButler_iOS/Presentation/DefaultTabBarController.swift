//
//  DefaultTabBarController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/03/30.
//

import UIKit

class DefaultTabBarController: UITabBarController {
    
    
    private let fridgeTab = UITabBarItem(title: nil, image: UIImage(named: "main"), selectedImage: UIImage(named: "main")) // TODO: .fill 아이콘으로 변경
    private let recipeTab = UITabBarItem(title: nil, image: UIImage(named: "recipe"), selectedImage: UIImage(named: "recipe.fill"))
    private let cartTab = UITabBarItem(title: nil, image: UIImage(named: "cart"), selectedImage: UIImage(named: "cart.fill"))
    private let mypageTab = UITabBarItem(title: nil, image: UIImage(named: "mypage"), selectedImage: UIImage(named: "mypage.fill"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setup()
    }
    private func setup() {
//        CartViewModel.shared.getCart(cartId: 1)
        
    }
    
    override func viewDidLayoutSubviews() {
        var tabFrame = tabBar.frame
        if UIDevice.hasNotch {
            tabFrame.size.height = 100
            tabFrame.origin.y = self.view.frame.size.height - 80
        } else {
            tabFrame.size.height = 60
            tabFrame.origin.y = self.view.frame.size.height - 50
        }
        tabBar.frame = tabFrame
        setLayoutTabBar()
    }
    
    private func setLayoutTabBar() {
        tabBar.clipsToBounds = true
        
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = .signatureBlue
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
    }
    
    private func configureTabBar() {
        self.tabBarController?.tabBar.tintColor = .black
        
        // TODO: 레시피, 마이페이지 관련 화면 생성 후 instatiate 관련 내용 수정
        var storyboard = UIStoryboard.init(name: "Fridge", bundle: nil)
        guard let fridgeViewController = storyboard.instantiateViewController(withIdentifier: "FridgeViewController") as? FridgeViewController else { return }
        let fridge = UINavigationController(rootViewController: fridgeViewController)
        fridge.tabBarItem = fridgeTab
        
        storyboard = UIStoryboard.init(name: "Fridge", bundle: nil)
        guard let recipeViewController = storyboard.instantiateViewController(withIdentifier: "FridgeViewController") as? FridgeViewController else { return }
        let recipe = UINavigationController(rootViewController: recipeViewController)
        recipe.tabBarItem = recipeTab
        
        storyboard = UIStoryboard.init(name: "Cart", bundle: nil)
        guard let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else { return }
        let cart = UINavigationController(rootViewController: cartViewController)
        cart.tabBarItem = cartTab
        
        storyboard = UIStoryboard.init(name: "AuthMain", bundle: nil)
        guard let mypageViewController = storyboard.instantiateViewController(withIdentifier: "AuthMainViewController") as? AuthMainViewController else { return }
        let mypage = UINavigationController(rootViewController: mypageViewController)
        mypage.tabBarItem = mypageTab
        
        viewControllers = [
            fridge,
            recipe,
            cart,
            mypage
        ]
    }
}
