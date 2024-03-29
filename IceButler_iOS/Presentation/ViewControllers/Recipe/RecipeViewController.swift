//
//  RecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/27.
//

import UIKit
import Tabman
import Pageboy

class RecipeViewController: TabmanViewController {

    @IBOutlet weak var recipeAddButton: UIButton!
    private var viewControllerList: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupTabman()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        FoodViewModel.shared.setIsSelectedFood(isSelected: false)
    }
    
    @objc func didTapStarButton(sender: UIButton!) {
        // 냉장고 미선택인 경우 레시피 조회 불가능
        if APIManger.shared.getFridgeIdx() == -1 {
            let alert = UIAlertController(title: "냉장고 미선택", message: "냉장고 미선택 상태입니다. 냉장고를 선택하셔야 레시피 조회가 가능합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)
            return
        }
        
        guard let bookmarkRecipeViewController = storyboard!.instantiateViewController(withIdentifier: "BookmarkRecipeViewController") as? BookmarkRecipeViewController else { return }
        self.navigationController?.pushViewController(bookmarkRecipeViewController, animated: true)
    }
    
    @objc func didTapSearchButton(sender: UIButton!) {
        // 냉장고 미선택인 경우 레시피 조회 불가능
        if APIManger.shared.getFridgeIdx() == -1 {
            let alert = UIAlertController(title: "냉장고 미선택", message: "냉장고 미선택 상태입니다. 냉장고를 선택하셔야 레시피 조회가 가능합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)
            return
        }
        
        guard let recipeSearchViewController = storyboard!.instantiateViewController(withIdentifier: "RecipeSearchViewController") as? RecipeSearchViewController else { return }
        self.navigationController?.pushViewController(recipeSearchViewController, animated: true)
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        guard let addRecipeViewController = storyboard!.instantiateViewController(withIdentifier: "AddRecipeViewController") as? AddRecipeViewController else { return }
        self.navigationController?.pushViewController(addRecipeViewController, animated: true)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        
        // left item
        let fixedSpace = UIBarButtonItem(systemItem: .fixedSpace)
        fixedSpace.width = 20
        let mainText = UILabel()
        mainText.text = "레시피"
        mainText.textColor = .white
        mainText.font = .systemFont(ofSize: 17, weight: .heavy)
        navigationItem.setLeftBarButtonItems([fixedSpace, UIBarButtonItem(customView: mainText)], animated: true)
        
        // right item
        let buttonItems: [UIBarButtonItem] = [UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(didTapStarButton)), UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .plain, target: self, action: #selector(didTapSearchButton))]
        navigationItem.setRightBarButtonItems(buttonItems, animated: true)
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.navigationColor
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.navigationColor
        }
    }
    
    private func setupLayout() {
        recipeAddButton.backgroundColor = .white
        recipeAddButton.layer.masksToBounds = true
        recipeAddButton.layer.cornerRadius = recipeAddButton.frame.height / 2
        recipeAddButton.layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 4, blur: 20, spread: 0)
    }
    
    private func setupTabman() {
        let popularRecipeVC = storyboard?.instantiateViewController(identifier: "PopularRecipeViewController") as! PopularRecipeViewController
        let recipeInFridgeVC = storyboard?.instantiateViewController(identifier: "RecipeInFridgeViewController") as! RecipeInFridgeViewController
        
        [popularRecipeVC, recipeInFridgeVC].forEach { vc in
            viewControllerList.append(vc)
        }
        
        self.dataSource = self
        setupTabBar()
    }
    
    private func setupTabBar() {
        let bar = TMBar.ButtonBar()
        
        bar.buttons.customize { (button) in
            button.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.tintColor = .notSelectedTabBarWhite
            button.selectedTintColor = .selectedTabBarWhite
        }
        
        bar.backgroundView.style = .clear
        bar.backgroundColor = .navigationColor
        bar.indicator.weight = .light
        bar.indicator.tintColor = .white
        bar.indicator.overscrollBehavior = .bounce
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 24
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        addBar(bar, dataSource: self, at: .top)
    }
}

extension RecipeViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: RecipeListType.allCases[index].rawValue)
    }
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllerList.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllerList[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
}
