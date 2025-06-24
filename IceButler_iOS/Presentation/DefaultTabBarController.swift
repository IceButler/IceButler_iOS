//
//  DefaultTabBarController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/03/30.
//

import UIKit

class DefaultTabBarController: UITabBarController {
    
    
    private let fridgeTab = UITabBarItem(title: nil, image: UIImage(named: "main"), selectedImage: UIImage(named: "main.fill"))
    private let receiptScanTab = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), selectedImage: UIImage(systemName: "camera.fill"))
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
        
        var storyboard = UIStoryboard.init(name: "Fridge", bundle: nil)
        guard let fridgeViewController = storyboard.instantiateViewController(withIdentifier: "FridgeViewController") as? FridgeViewController else { return }
        let fridge = UINavigationController(rootViewController: fridgeViewController)
        fridge.tabBarItem = fridgeTab
        
        // 영수증 스캔 화면 (임시로 PlaceholderViewController 사용)
        let receiptScanViewController = UIViewController()
        receiptScanViewController.view.backgroundColor = .systemBackground
        receiptScanViewController.title = "영수증 스캔"
        let receiptScan = UINavigationController(rootViewController: receiptScanViewController)
        receiptScan.tabBarItem = receiptScanTab
        
        storyboard = UIStoryboard.init(name: "MyPage", bundle: nil)
        guard let mypageViewController = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else { return }
        let mypage = UINavigationController(rootViewController: mypageViewController)
        mypage.tabBarItem = mypageTab
        
        viewControllers = [
            fridge,
            receiptScan,
            mypage
        ]
    }
}
