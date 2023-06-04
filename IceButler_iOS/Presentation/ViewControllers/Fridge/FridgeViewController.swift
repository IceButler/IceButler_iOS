//
//  FridgeViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/05.
//

import UIKit
import Tabman
import Pageboy
import Toast_Swift


class FridgeViewController: TabmanViewController {

    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var foodAddButton: UIButton!
    
    
    @IBOutlet weak var noFridgeImageView: UIImageView!
    @IBOutlet weak var noFridgeLabel: UILabel!
    @IBOutlet weak var fridgeAddButton: UIButton!
    
    @IBOutlet var deleteSelectedView: UIView!
    
    private var viewControllerList: Array<UIViewController> = []
    
    private var bar: TMBar.ButtonBar!
    private var isBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        setupNavigationBar()
        setupLayout()
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setup() {
        FridgeViewModel.shared.setSavedFridgeIdx()
        FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
        
        deleteSelectedView.isHidden = true
        
    }
    
    private func setupObserver() {
        APIManger.shared.fridgeIdx { fridgeIdx in
            if fridgeIdx == -1 {
                self.noFridgeImageView.isHidden = false
                self.noFridgeLabel.isHidden = false
                self.fridgeAddButton.isHidden = false
                self.foodAddButton.isHidden = true
                if let bar = self.bar {
                    self.removeBar(bar)
                }
                self.setupleftBarItems(title: "냉장고 미선택")
            }else {
                FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
                self.noFridgeImageView.isHidden = true
                self.noFridgeLabel.isHidden = true
                self.fridgeAddButton.isHidden = true
                self.foodAddButton.isHidden = false
                if self.isBar == false {
                    self.setupTabman()
                }else {
                    self.addBar(self.bar, dataSource: self, at: .top)
                }
            }
        }
        
        
        AuthViewModel.shared.isJoin { isJoin in
            if isJoin {
                self.view.makeToast("회원가입이 완료되었습니다!", duration: 1.0, position: .center)
            }
        }
        
        FoodViewModel.shared.isSelectedFood { isSelectedFood in
            if isSelectedFood {
                self.deleteSelectedView.isHidden = false
            }else {
                self.deleteSelectedView.isHidden = true
            }
        }
    }
    
    private func setupTabman() {
        let allFoodVC = storyboard?.instantiateViewController(identifier: "AllFoodViewController") as! AllFoodViewController
        let meatVC = storyboard?.instantiateViewController(identifier: "MeatViewController") as! MeatViewController
        let fruitVC = storyboard?.instantiateViewController(withIdentifier: "FruitViewController") as! FruitViewController
        let vegetableVC = storyboard?.instantiateViewController(withIdentifier: "VegetableViewController") as! VegetableViewController
        let drinkVC = storyboard?.instantiateViewController(withIdentifier: "DrinkViewController") as! DrinkViewController
        let marineProductsVC = storyboard?.instantiateViewController(withIdentifier: "MarineProductsViewController") as! MarineProductsViewController
        let sideVC = storyboard?.instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        let seassoningVC = storyboard?.instantiateViewController(withIdentifier: "SeasoningViewController") as! SeasoningViewController
        let processedFoodVC = storyboard?.instantiateViewController(withIdentifier: "ProcessedFoodViewController") as! ProcessedFoodViewController
        let etcVC = storyboard?.instantiateViewController(withIdentifier: "ETCViewController") as! ETCViewController
        
        [allFoodVC, meatVC, fruitVC, vegetableVC, drinkVC, marineProductsVC, sideVC, seassoningVC, processedFoodVC, etcVC].forEach { vc in
            viewControllerList.append(vc)
        }
        
        self.dataSource = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        bar = TMBar.ButtonBar()
        
        bar.backgroundView.style = .clear
        
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
        isBar = true
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        fridgeAddButton.layer.cornerRadius = 20
        foodAddButton.backgroundColor = .white
        foodAddButton.layer.cornerRadius = foodAddButton.frame.width / 2
        foodAddButton.layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 4, blur: 20, spread: 0)
    }
    
    private func setupNavigationBar() {
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
        
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        
        setupleftBarItems(title: FridgeViewModel.shared.defaultFridgeName)
//        print("FridgeViewModel.shared.defaultFridgeName --> \(FridgeViewModel.shared.defaultFridgeName)")
        
        let searchItem = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .done, target: self, action: #selector(moveToSearchVC))
        searchItem.tintColor = .white
        let alarmItem = UIBarButtonItem(image: UIImage(named: "alarmIcon"), style: .done, target: self, action: #selector(moveToAlarmVC))
        alarmItem.tintColor = .white
        
        self.navigationItem.rightBarButtonItems = [alarmItem, searchItem]
    }
    
    private func setupleftBarItems(title: String) {
        let backItem = UIBarButtonItem(image: UIImage(named: "fridgeSelectIcon"), style: .done, target: self, action: #selector(selectFridge))
        backItem.tintColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [titleItem, backItem]
    }
    
    @objc private func selectFridge() {
        guard let vc = storyboard?.instantiateViewController(identifier: "SelectFrideViewController") as? SelectFrideViewController else { return }
        vc.delegate = self
        let selectVC = UINavigationController(rootViewController: vc)
        selectVC.isNavigationBarHidden = true
        present(selectVC, animated: true)
    }
    
    @objc private func moveToSearchVC() {
        let searchFoodVC = UIStoryboard(name: "SearchFood", bundle: nil).instantiateViewController(withIdentifier: "SearchFoodViewController") as! SearchFoodViewController
        
        searchFoodVC.setSearchCategory(searchCategory: .Fridge)
        
        self.navigationController?.pushViewController(searchFoodVC, animated: true)
    }
    
    @objc private func moveToAlarmVC() {
        let notificationVC = UIStoryboard(name: "Notification", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    

    @IBAction func fridgeAdd(_ sender: Any) {
        let fridgeAddVC = UIStoryboard(name: "Fridge", bundle: nil).instantiateViewController(withIdentifier: "AddFridgeViewController") as! AddFridgeViewController
        fridgeAddVC.delegate = self
        fridgeAddVC.modalPresentationStyle = .overFullScreen
        present(fridgeAddVC, animated: true)
    }
    

    @IBAction func foodAdd(_ sender: Any) {
        moveToFoodAddSelectVC(animate: true)
    }
    
    @IBAction func foodDelete(_ sender: Any) {
        let alertVC = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(identifier: "AlertViewController") as! AlertViewController
        
        alertVC.configure(title: "식품 삭제", content: "해당 식품을 삭제하시겠습니까?", leftButtonTitle: "취소", righttButtonTitle: "삭제") {
            FoodViewModel.shared.deleteFoods { result in
                if result {
                    self.view.makeToast("해당 식품이 정상적으로 삭제되었습니다.", duration: 1.0, position: .center)
                }else {
                    self.view.makeToast("식품 삭제에 오류가 발생하였습니다. 다시 시도해주세요.", duration: 1.0, position: .center)
                }
            }
        } leftCompletion: {
        }
        
        alertVC.modalPresentationStyle = .overFullScreen

        self.present(alertVC, animated: true)
    }
    
    
    @IBAction func foodEat(_ sender: Any) {
        
        let alertVC = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(identifier: "AlertViewController") as! AlertViewController
        
        alertVC.configure(title: "식품 섭취", content: "해당 식품을 섭취하시겠습니까?", leftButtonTitle: "취소", righttButtonTitle: "섭취") {
            FoodViewModel.shared.eatFoods { result in
                if result {
                    self.view.makeToast("해당 식품이 정상적으로 섭취 처리되었습니다.", duration: 1.0, position: .center)
                }else {
                    self.view.makeToast("식품 섭취 처리에 오류가 발생하였습니다. 다시 시도해주세요.", duration: 1.0, position: .center)
                }
            }
        } leftCompletion: {
        }
        
        alertVC.modalPresentationStyle = .overFullScreen

        self.present(alertVC, animated: true)

    }
    
    private func moveToFoodAddSelectVC(animate: Bool) {
        foodAddButton.isHidden = true
        
        let foodAddVC = UIStoryboard(name: "FoodAddSelect", bundle: nil).instantiateViewController(identifier: "FoodAddSelectViewController") as! FoodAddSelectViewController
        foodAddVC.setupDelegate(delegate: self)
        
        foodAddVC.modalTransitionStyle = .crossDissolve
        foodAddVC.modalPresentationStyle = .overFullScreen
        
        self.present(foodAddVC, animated: animate)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}


extension FridgeViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllerList.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        FoodViewModel.shared.setIsSelectedFood(isSelected: false)
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
    
    func moveToSearchFoodVC(searchFoodVC: SearchFoodViewController) {
        searchFoodVC.setFridgeDelegate(fridgeDelegate: self)
        searchFoodVC.setSearchCategory(searchCategory: .Food)
        navigationController?.pushViewController(searchFoodVC, animated: true)
    }
}

extension FridgeViewController: FoodAddDelegate, SelectFridgeDelegate {
    func moveToFoodAddSelect() {
        moveToFoodAddSelectVC(animate: false)
    }
    
    func updateMainFridge(title: String) {
        setupleftBarItems(title: title)
        FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
    }
}


extension FridgeViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}

extension FridgeViewController: AddFridgeDelegate {
    func setNewFidgeNameTitle(name: String) {
        setupleftBarItems(title: name)
        FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
    }
}
