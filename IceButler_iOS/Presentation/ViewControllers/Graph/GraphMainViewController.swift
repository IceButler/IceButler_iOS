//
//  GraphMainViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/06.
//

import UIKit
import Tabman
import Pageboy

class GraphMainViewController: TabmanViewController {
    
    private var viewControllerList: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabman()
    }
    
    
    private func setupTabman() {
        let allFoodVC = UIStoryboard(name: "Fridge", bundle: nil).instantiateViewController(identifier: "AllFoodViewController") as! AllFoodViewController
        let meatVC = UIStoryboard(name: "Fridge", bundle: nil).instantiateViewController(identifier: "MeatViewController") as! MeatViewController
       
        
        [allFoodVC, meatVC].forEach { vc in
            viewControllerList.append(vc)
        }
        
        self.dataSource = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let bar = TMBar.ButtonBar()
        
        bar.backgroundView.style = .clear
        
        bar.buttons.customize { (button) in
            let tmpLabel = UILabel()
            tmpLabel.text = button.text
            tmpLabel.font = UIFont.systemFont(ofSize: 15)
            button.frame.size = tmpLabel.frame.size
            
            button.contentVerticalAlignment = .center
            button.font = UIFont.systemFont(ofSize: 15)
            button.tintColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
            button.selectedTintColor = .signatureBlue
        }
        
        bar.backgroundColor = .white
        
        bar.indicator.weight = .light
        bar.indicator.tintColor = .signatureBlue
        bar.indicator.overscrollBehavior = .bounce
        
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 165
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 20.0)
        
        addBar(bar, dataSource: self, at: .top)
    }

}


extension GraphMainViewController: PageboyViewControllerDataSource, TMBarDataSource {
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
            return TMBarItem(title: "낭비")
        }else{
            return TMBarItem(title: "소비")
        }
    }
}

