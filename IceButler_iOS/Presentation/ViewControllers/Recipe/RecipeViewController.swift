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

    private var searchBar: UISearchBar! = nil
    private var viewControllerList: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        initSearchBar()
        setupTabman()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSearchBarRightView()
    }
    
    private func fetchData() {
        if APIManger.shared.getIsMultiFridge() {
            RecipeViewModel.shared.getFridgeRecipeList(fridgeType: FridgeType.multiUse, fridgeIdx: APIManger.shared.getFridgeIdx())
        } else {
            RecipeViewModel.shared.getFridgeRecipeList(fridgeType: FridgeType.homeUse, fridgeIdx: APIManger.shared.getFridgeIdx())
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        // left item
        let mainText = UILabel()
        mainText.text = "레시피"
        mainText.textColor = .white
        mainText.font = .systemFont(ofSize: 17, weight: .bold)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainText)
        // right item
        let bookmarkBtn = UIButton()
        bookmarkBtn.setImage(UIImage(named: "star"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkBtn)
        
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
    
    private func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.layoutIfNeeded()
        searchBar.layoutSubviews()
        searchBar.placeholder = "식품 재료/메뉴명"
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.font = .systemFont(ofSize: 16, weight: .regular)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        searchBar.searchTextField.layer.cornerRadius = 22
        searchBar.searchTextField.layer.masksToBounds = true
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        // 왼쪽 기본 돋보기 이미지 빼기
        searchBar.searchTextField.leftViewMode = .never
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        
        // titleView
        self.navigationItem.titleView = searchBar
    }
    
    private func setSearchBarRightView() {
        // 오른쪽에 검색 버튼(돋보기) 넣기
        searchBar.searchTextField.clearButtonMode = .never
        let searchBtn = UIButton(type: .custom)
        searchBtn.setImage(UIImage(named: "searchIcon"), for: .normal)
        searchBar.searchTextField.rightView = searchBtn
        searchBar.searchTextField.rightViewMode = .always
    }
    
    private func setupTabman() {
        let recipeInFridgeVC = storyboard?.instantiateViewController(identifier: "RecipeInFridgeViewController") as! RecipeInFridgeViewController
        let popularRecipeVC = storyboard?.instantiateViewController(identifier: "PopularRecipeViewController") as! PopularRecipeViewController
        
        [recipeInFridgeVC, popularRecipeVC].forEach { vc in
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
        return TMBarItem(title: RecipeCategory.allCases[index].rawValue)
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
