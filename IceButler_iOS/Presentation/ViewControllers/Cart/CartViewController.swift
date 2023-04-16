//
//  CartViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/03/30.
//

import UIKit


class CartViewController: UIViewController {
    @IBOutlet weak var cartMainTableView: UITableView!
    @IBOutlet weak var addFoodButton: UIButton!
//    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var completeBuyingButton: UIButton!
    
    private var cartFoods: [CartResponseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        congifure()
        setup()
        setupNavigationBar()
        setupLayout()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.alertView.isHidden = true
        self.addFoodButton.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func congifure() {
        CartViewModel.shared.fetchData()
        CartViewModel.shared.getCartFoods { cartFoods in
            self.cartFoods = cartFoods
            self.cartMainTableView.reloadData()
            self.viewHeightConstraint.constant = CGFloat(170 * self.cartFoods.count)
        }
//        deleteButton.addTarget(self, action: #selector(didTapDeleteFoodButton), for: .allTouchEvents)
    }
    
    func setup() { CartManager.shared.setCartVC(cartVC: self) }
    
    @IBAction func didTapAddFoodButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Cart", bundle: nil)
        guard let addFoodViewController = storyboard.instantiateViewController(withIdentifier: "AddFoodViewController") as? AddFoodViewController else { return }
        self.navigationController?.pushViewController(addFoodViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
    }
    
    @IBAction func didTapDeleteFoodButton(_ sender: UIButton) {
        print("didTapDeleteFoodButton called")
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        alertViewController.configure(title: "식품 삭제",
                                      content: "선택하신 식품을 정말 삭제하시겠습니까?",
                                      leftButtonTitle: "취소", righttButtonTitle: "삭제")
        alertViewController.todo = .delete
        alertViewController.modalPresentationStyle = .overCurrentContext
        present(alertViewController, animated: true)
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        print("didTapCompleteButton called")
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        alertViewController.configure(title: "장보기 완료",
                                      content: "선택하신 식품 장보기를 완료하셨습니까?",
                                      leftButtonTitle: "취소", righttButtonTitle: "확인")
        alertViewController.todo = .completeBuying
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
            statusbarView.backgroundColor = UIColor.signatureLightBlue
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
        
        self.navigationController?.navigationBar.backgroundColor = .signatureLightBlue
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    private func setupLayout() {
        self.cartMainTableView.backgroundColor = .clear
        self.alertView.layer.cornerRadius = 15
        self.addFoodButton.backgroundColor = UIColor.signatureDeepBlue
        self.addFoodButton.backgroundColor = UIColor.signatureDeepBlue
        self.addFoodButton.layer.cornerRadius = self.addFoodButton.frame.width / 2
    }
    
    
    private func setupTableView() {
        cartMainTableView.separatorStyle = .none
        cartMainTableView.isScrollEnabled = false
        cartMainTableView.delegate = self
        cartMainTableView.dataSource = self
        cartMainTableView.register(UINib(nibName: "CartMainTableViewCell", bundle: nil), forCellReuseIdentifier: "CartMainTableViewCell")
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.cartFoods.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartMainTableViewCell", for: indexPath) as? CartMainTableViewCell else { return UITableViewCell() }
        cell.setTitle(title: self.cartFoods[indexPath.row].category)
        cell.cartFoods = CartViewModel.shared.getCartFoodsWithCategory(index: indexPath.row)
        cell.backgroundColor = cell.contentView.backgroundColor
        return cell
    }
}
