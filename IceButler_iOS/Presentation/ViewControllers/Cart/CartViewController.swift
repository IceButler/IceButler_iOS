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
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationBar()
        setupLayout()
        setupTableView()
        setupObserver()
    }
    
    func setup() {
        CartManager.shared.setCartVC(cartVC: self)
    }
    
    private func setupObserver() {
        CartViewModel.shared.isremoveFoodIdxes { edit in
            if edit {
                self.tabBarController?.tabBar.isHidden = true
                self.addFoodButton.isHidden = true
                self.alertView.backgroundColor = .signatureDeepBlue
                self.alertView.isHidden = false
            } else {
                self.tabBarController?.tabBar.isHidden = false
                self.addFoodButton.isHidden = false
                self.alertView.isHidden = true
            }
        }
    }
    
    @IBAction func didTapAddFoodButton(_ sender: UIButton) {
        // TODO: 식품 추가 커스텀 팝업 띄우기
    }
    
    
    @IBAction func didTapDeleteFoodButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        alertViewController.configure(title: "식품 삭제",
                                      content: "선택하신 식품을 정말 삭제하시겠습니까?",
                                      leftButtonTitle: "취소", righttButtonTitle: "삭제")
        alertViewController.delegate = self
        
//        alertViewController.setLeftButtonAction(action: #selector(cancelAction(alertViewController)))
//        alertViewController.setRightButtonAction(action: #selector(deleteAction(alertViewController)))
        alertViewController.modalPresentationStyle = .overCurrentContext
        present(alertViewController, animated: true)
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        alertViewController.configure(title: "장보기 완료",
                                      content: "선택하신 식품 장보기를 완료하셨습니까?",
                                      leftButtonTitle: "취소", righttButtonTitle: "확인")
        alertViewController.modalPresentationStyle = .overCurrentContext
        present(alertViewController, animated: true)
    }
    
    func cancelAction(_ sender: UIViewController) { sender.dismiss(animated: true) }
    @objc func deleteAction(_ sender: UIViewController) {
        print("식품 삭제 로직 추가 예정")
        sender.dismiss(animated: true)
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.addFoodButton.isHidden = false
        self.alertView.isHidden = true
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartMainTableViewCell", for: indexPath) as? CartMainTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.setTitle(title: "전체")
        cell.backgroundColor = cell.contentView.backgroundColor
        return cell
    }
}

extension CartViewController: MainTableViewDelegate {
    func deleteFood(index: Int, row: Int) {
//        print("CartViewController :: deleteFood called")
//        let category = CartManager.shared.categoryTitleArr[row]
//        CartManager.shared.tempFoods[category]?.remove(at: index)
//        self.cartMainTableView.reloadData()
    }
    
    func setEditMode(edit: Bool) {
        if edit {
            self.tabBarController?.tabBar.isHidden = true
            self.addFoodButton.isHidden = true
            self.alertView.backgroundColor = .signatureDeepBlue
            self.alertView.isHidden = false
        } else {
            self.tabBarController?.tabBar.isHidden = false
            self.addFoodButton.isHidden = false
            self.alertView.isHidden = true
        }
        
    }
}

extension CartViewController: AlertDelegate {
    func deleteFoodsAction() {
        print("deleteFoodsAction called")
//        CartManager.shared.deleteFood()
//        self.cartMainTableView.reloadData()
//        self.setEditMode(edit: false)
//        CartManager.shared.status = .done
    }
}
