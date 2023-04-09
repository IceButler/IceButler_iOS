//
//  FridgeViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/05.
//

import UIKit
import Tabman
import Pageboy


class FridgeViewController: TabmanViewController {

    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var foodAddButton: UIButton!
    
    private var viewControllerList: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabman()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    
    private func setupTabman() {
        let allFoodVC = storyboard?.instantiateViewController(identifier: "AllFoodViewController") as! AllFoodViewController
        let meatVC = storyboard?.instantiateViewController(identifier: "MeatViewController") as! MeatViewController
        let fruitVC = storyboard?.instantiateViewController(withIdentifier: "FruitViewController") as! FruitViewController
        let vegetableVC = storyboard?.instantiateViewController(withIdentifier: "VegetableViewController") as! VegetableViewController
        let drinkVC = storyboard?.instantiateViewController(withIdentifier: "DrinkViewController") as! DrinkViewController
        let marineProductsVC = storyboard?.instantiateViewController(withIdentifier: "MarineProductsViewController") as! MarineProductsViewController
        let sideVC = storyboard?.instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        let snakVC = storyboard?.instantiateViewController(withIdentifier: "SnackViewController") as! SnackViewController
        let seassoningVC = storyboard?.instantiateViewController(withIdentifier: "SeasoningViewController") as! SeasoningViewController
        let processedFoodVC = storyboard?.instantiateViewController(withIdentifier: "ProcessedFoodViewController") as! ProcessedFoodViewController
        let etcVC = storyboard?.instantiateViewController(withIdentifier: "ETCViewController") as! ETCViewController
        
        [allFoodVC, meatVC, fruitVC, vegetableVC, drinkVC, marineProductsVC, sideVC, snakVC, seassoningVC, processedFoodVC, etcVC].forEach { vc in
            viewControllerList.append(vc)
        }
        
        self.dataSource = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let bar = TMBar.ButtonBar()
        
        bar.backgroundView.style = .blur(style: .regular)
        
        bar.buttons.customize { (button) in
            let tmpLabel = UILabel()
            tmpLabel.text = button.text
            tmpLabel.font = UIFont.systemFont(ofSize: 15)
            button.frame.size = tmpLabel.frame.size
            
            button.font = UIFont.systemFont(ofSize: 15)
            button.tintColor = .notSelectedTabBarWhite
            button.selectedTintColor = .selectedTabBarWhite
        }
        
        bar.backgroundColor = .navigationColor
        
        bar.indicator.weight = .light
        bar.indicator.tintColor = .white
        bar.indicator.overscrollBehavior = .bounce
        
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 26
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        foodAddButton.backgroundColor = .signatureDeepBlue
        
        foodAddButton.layer.cornerRadius = foodAddButton.frame.width / 2
        foodAddButton.layer.shadowColor = CGColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        foodAddButton.layer.shadowOpacity = 1
        foodAddButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    @IBAction func foodAdd(_ sender: Any) {
        moveToFoodAddSelectVC(animate: true)
    }
    
    private func moveToFoodAddSelectVC(animate: Bool) {
        foodAddButton.isHidden = true
        
        let foodAddVC = UIStoryboard(name: "FoodAddSelect", bundle: nil).instantiateViewController(identifier: "FoodAddSelectViewController") as! FoodAddSelectViewController
        foodAddVC.setupDelegate(delegate: self)
        
        foodAddVC.modalTransitionStyle = .crossDissolve
        foodAddVC.modalPresentationStyle = .overFullScreen
        
        self.present(foodAddVC, animated: animate)
    }
}


extension FridgeViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllerList.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllerList[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        if index == 0 {
            return TMBarItem(title: "전체")
        }else{
            return TMBarItem(title: FoodCategory.allCases[index-1].rawValue)
        }
    }
    
    
}




extension FridgeViewController: FoodAddSelectDelgate {
    func showFoodAddButton() {
        foodAddButton.isHidden = false
    }
    
    func moveToFoodAddViewController(foodAddVC: FoodAddViewController) {
        foodAddVC.setDelegate(delegate: self)
        navigationController?.pushViewController(foodAddVC, animated: true)
    }
}

extension FridgeViewController: FoodAddDelegate {
    func moveToFoodAddSelect() {
        moveToFoodAddSelectVC(animate: false)
    }
}
