//
//  CartViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/03/30.
//

import UIKit
import JGProgressHUD
import CoreLocation
import Toast_Swift

class CartViewController: UIViewController {
    @IBOutlet weak var cartMainTableView: UITableView!
    @IBOutlet weak var noRefrigeratorView: UIView!
    @IBOutlet weak var nothingFoodLabel: UILabel!
    @IBOutlet weak var addFoodButton: UIButton!
    
    @IBOutlet weak var addRefrigeratorButton: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var completeBuyingButton: UIButton!
    
    private var cartFoods: [CartResponseModel] = []
    private var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLocation()
        
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            self.configure()
            self.setup()
            self.setupLayout()
            self.setupTableView()
            
            hud.dismiss(animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FoodViewModel.shared.setIsSelectedFood(isSelected: false)
        CartViewModel.shared.removeFoodIdxes?.removeAll()
        CartViewModel.shared.removeFoodNames.removeAll()
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            self.configure()
            
            hud.dismiss(animated: true)
        }

        self.alertView.isHidden = true
        self.addFoodButton.isHidden = false
        self.setupNavigationBar()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// 장바구니 조회 요청 메소드
    func fetchCartData(urlStr: String) {
        APIManger.shared.getData(urlEndpointString: urlStr,
                                 responseDataType: [CartResponseModel].self,
                                 requestDataType: [CartResponseModel].self,
                                 parameter: nil) { [weak self] response in
            
            switch response.statusCode {
            case 200:
                self?.noRefrigeratorView.isHidden = true
                self?.addFoodButton.isHidden = false
                self?.cartFoods.removeAll()
                self?.cartFoods = response.data!
                self?.cartMainTableView.reloadData()
                self?.viewHeightConstraint.constant = CGFloat(170 * (self?.cartFoods.count ?? 0))
                if self?.cartFoods.count == 0 {
                    self?.cartMainTableView.isHidden = true
                    self?.nothingFoodLabel.isHidden = false
                } else {
                    self?.cartMainTableView.isHidden = false
                    self?.nothingFoodLabel.isHidden = true
                }
            case 403, 404:
                self?.noRefrigeratorView.isHidden = false
                self?.addFoodButton.isHidden = true
                
            default: return
            }
            
        }
    }
    func configure() {
        if APIManger.shared.getIsMultiFridge() {
            let idx = APIManger.shared.getFridgeIdx()
            fetchCartData(urlStr: "/multiCarts/\(idx)/foods")
            
        } else {
            let idx = APIManger.shared.getFridgeIdx()
            fetchCartData(urlStr: "/carts/\(idx)/foods")
        }
    }
    
    func setup() { CartViewModel.shared.setCartVC(cartVC: self) }
    
    func resetTableView(data: [CartResponseModel]) {
        cartFoods.removeAll()
        cartFoods = data
        self.cartMainTableView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "장바구니 식품 조회에 실패하였습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func didTapAddFridgeButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Fridge", bundle: nil)
        guard let addFridgeVC = storyboard.instantiateViewController(withIdentifier: "AddFridgeViewController") as? AddFridgeViewController else { return }
        addFridgeVC.delegate = self
        addFridgeVC.modalPresentationStyle = .overFullScreen
        present(addFridgeVC, animated: true)
    }
    
    
    @IBAction func didTapAddFoodButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Cart", bundle: nil)
        guard let addFoodViewController = storyboard.instantiateViewController(withIdentifier: "AddFoodViewController") as? AddFoodViewController else { return }
        self.navigationController?.pushViewController(addFoodViewController, animated: true)
    }
    
    @IBAction func didTapDeleteFoodButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        alertViewController.configure(title: "식품 삭제",
                                      content: "선택하신 식품을 정말 삭제하시겠습니까?",
                                      leftButtonTitle: "취소",
                                      righttButtonTitle: "삭제",
                                      rightCompletion: { CartViewModel.shared.deleteFood(cartId: APIManger.shared.getFridgeIdx()) },
                                      leftCompletion: { })

        alertViewController.modalPresentationStyle = .overCurrentContext
        present(alertViewController, animated: true)
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        alertViewController.configure(title: "장보기 완료",
                                      content: "선택하신 식품 장보기를 완료하셨습니까?",
                                      leftButtonTitle: "취소",
                                      righttButtonTitle: "확인",
                                      rightCompletion: {
            CartViewModel.shared.deleteFood(cartId: APIManger.shared.getFridgeIdx())
            
            let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
            guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "SelectAlertViewController") as? CompleteBuyingViewController else { return }
            alertViewController.delegate = self
            CartViewModel.shared.removeFoodIdxes?.forEach({ idx in
                let i = CartViewModel.shared.removeFoodIdxes?.firstIndex(of: idx) ?? 0
                let name = CartViewModel.shared.removeFoodNames[i]
                alertViewController.completeFoods.append(BuyedFood(idx: idx, name: name))
            })
//            alertViewController.modalPresentationStyle = .overCurrentContext
//            self.present(alertViewController, animated: true)

            self.navigationController?.pushViewController(alertViewController, animated: true)
            },
                                      leftCompletion: {
//            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
            })
        alertViewController.modalPresentationStyle = .overCurrentContext
        present(alertViewController, animated: true)
    }
    
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.addFoodButton.isHidden = false
        self.alertView.isHidden = true
        viewHeightConstraint.constant = CGFloat(170 * (cartFoods.count))
    }
    
    func showAlertView() {
        self.addFoodButton.isHidden = true
        self.alertView.backgroundColor = .signatureBlue
        self.alertView.isHidden = false
        viewHeightConstraint.constant = CGFloat(170 * (cartFoods.count) + 120)
    }
    
    
    private func setupNavigationBar() {
        /// setting status bar background color
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
            statusBar?.backgroundColor = UIColor.white
        }
        
        /// set up title
        let titleLabel = UILabel()
        titleLabel.text = "장바구니"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItem = titleItem
        
        /// set up right item
        let mapItem = UIBarButtonItem(image: UIImage(named: "mapIcon"), style: .done, target: self, action: #selector(didTapMapItem))
        mapItem.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = mapItem
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupLayout() {
        self.cartMainTableView.backgroundColor = .clear
        self.addFoodButton.backgroundColor = UIColor.white
        self.addFoodButton.layer.cornerRadius = self.addFoodButton.frame.width / 2
        self.addFoodButton.layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 4, blur: 20, spread: 0)
        self.addRefrigeratorButton.layer.cornerRadius = 22
    }
    
    
    private func setupTableView() {
        cartMainTableView.separatorStyle = .none
        cartMainTableView.isScrollEnabled = false
        cartMainTableView.delegate = self
        cartMainTableView.dataSource = self
        cartMainTableView.register(UINib(nibName: "CartMainTableViewCell", bundle: nil), forCellReuseIdentifier: "CartMainTableViewCell")

    }
    
    public func reloadFoodData() {
//        CartViewModel.shared.fetchData()
        self.cartFoods.removeAll()
        self.cartFoods = CartViewModel.shared.cartFoods
        self.cartMainTableView.reloadData()
    }
    
    
    // MARK: @objc methods
    @objc private func didTapMapItem() {
        guard let vc = storyboard?.instantiateViewController(identifier: "MapViewController") as? MapViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.cartFoods.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartMainTableViewCell", for: indexPath) as? CartMainTableViewCell else { return UITableViewCell() }
        cell.setTitle(title: self.cartFoods[indexPath.row].category)
        cell.cartFoods = self.cartFoods[indexPath.row].cartFoods
        cell.reloadCV()
        cell.backgroundColor = cell.contentView.backgroundColor
        return cell
    }
}

extension CartViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 거부됨")
            locationManager.requestWhenInUseAuthorization()
        default: return
        }
    }
}

extension CartViewController: AddFridgeDelegate {
    func setNewFidgeNameTitle(name: String) {
        configure()
        FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
    }
}

extension CartViewController: CompleteBuyingDelegate {
    func showToast(message: String) {
        self.view.makeToast("선택한 식품을 성공적으로 냉장고에 추가하였습니다!", duration: 1.5, position: .center)
    }
}
