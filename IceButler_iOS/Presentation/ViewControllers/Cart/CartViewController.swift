//
//  CartViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/03/30.
//

import UIKit


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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setup()
        setupNavigationBar()
        setupLayout()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
        self.alertView.isHidden = true
        self.addFoodButton.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
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
            case 403:
                self?.noRefrigeratorView.isHidden = false
                
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
            CartViewModel.shared.deleteFood(cartId: APIManger.shared.getFridgeIdx())  // 임시 ID
            
            let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
            guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "SelectAlertViewController") as? CompleteBuyingViewController else { return }
            CartViewModel.shared.removeFoodIdxes?.forEach({ idx in
                let i = CartViewModel.shared.removeFoodIdxes?.firstIndex(of: idx) ?? 0
                let name = CartViewModel.shared.removeFoodNames[i]
                alertViewController.completeFoods.append(BuyedFood(idx: idx, name: name))
            })
//            alertViewController.completeFoods = CartViewModel.shared.removeFoodNames
            self.navigationController?.pushViewController(alertViewController, animated: true)
            },
                                      leftCompletion: {
            
            })
        self.navigationController?.pushViewController(alertViewController, animated: true)
    }
    
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.addFoodButton.isHidden = false
        self.alertView.isHidden = true
    }
    
    func showAlertView() {
        self.tabBarController?.tabBar.isHidden = true
        self.addFoodButton.isHidden = true
        self.alertView.backgroundColor = .signatureBlue
        self.alertView.isHidden = false
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
            statusBar?.backgroundColor = UIColor.red
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
        
    }
    
    private func setupLayout() {
        self.cartMainTableView.backgroundColor = .clear
        self.alertView.layer.cornerRadius = 15
        self.addFoodButton.backgroundColor = UIColor.signatureDeepBlue
        self.addFoodButton.backgroundColor = UIColor.signatureDeepBlue
        self.addFoodButton.layer.cornerRadius = self.addFoodButton.frame.width / 2
        self.addRefrigeratorButton.layer.cornerRadius = 15
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
        let vc = MapViewController()
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
