//
//  CartViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/03/30.
//

import UIKit

class CartViewController: UIViewController {
    
    // 임시 데이터
    let categoryTitleArr = [
        "육류", "과일", "채소", "음료", "수산물", "반찬", "간식", "식재료", "가공식품", "기타"
    ]

    @IBOutlet weak var cartMainTableView: UITableView!
    @IBOutlet weak var addFoodButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupTableView()
    }
    
    @IBAction func didTapAddFoodButton(_ sender: UIButton) {
        // TODO: 식품 추가 커스텀 팝업 띄우기
    }
    
    
    @IBAction func didTapDeleteFoodButton(_ sender: UIButton) {
        // TODO: 선택된 식품 삭제 (커스텀 alert 화면으로 전환)
        print("didTapDeleteFoodButton")
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        // TODO: 장보기 완료 로직 추가 (커스텀 alert 화면으로 전환)
        print("didTapCompleteButton")
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
        
    }
    
    private func setupLayout() {
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
        return categoryTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartMainTableViewCell", for: indexPath) as? CartMainTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.setTitle(title: categoryTitleArr[indexPath.row])
        return cell
    }
}

extension CartViewController: MainTableViewDelegate {
    func setEditMode(edit: Bool) {
        if edit {
//            self.tabBarController?.tabBar.isHidden = true
            self.addFoodButton.isHidden = true
            self.alertView.backgroundColor = .signatureDeepBlue
            self.alertView.isHidden = false
        } else {
//            self.tabBarController?.tabBar.isHidden = false
            self.addFoodButton.isHidden = false
            self.alertView.isHidden = true
        }
        
    }
}
