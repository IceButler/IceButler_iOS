//
//  AddFoodViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/07.
//

import UIKit

// MARK: 장바구니에서 플로팅 버튼을 탭하는 경우 나오는 '식품 추가' 화면
class AddFoodViewController: UIViewController {

    private let category = [
        "육류", "과일", "채소", "음료", "수산물", "반찬", "간식", "조미료", "가공식품", "기타"
    ]
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var searchResultContainerView: UIView!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.backgroundColor = .signatureLightBlue
        self.tabBarController?.tabBar.isHidden = true
        
        setupNavigationBar()
        setupLayouts()
        setup()
    }
    
    // MARK: helper methods
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        // TODO: 장바구니 식품 추가 API 호출
    }
    
    @IBAction func didTapBackItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        searchResultContainerView.isHidden = false
        self.view.endEditing(true)
        
        // TODO: 검색어가 포함된 검색 결과를 GET -> searchResultTableView에 보이기
    }
    
    // MARK: helper methods
    private func setupNavigationBar() {
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
            statusBar?.backgroundColor = UIColor.signatureLightBlue
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    private func setupLayouts() {
        self.searchContainerView.layer.cornerRadius = 23
        self.searchTextField.borderStyle = .none
        self.completeButton.backgroundColor = .systemGray5
        self.completeButton.tintColor = .white
//        self.completeButton.backgroundColor = UIColor.signatureBlue
        self.completeButton.layer.cornerRadius = 23
        
        searchResultContainerView.layer.cornerRadius = 23
        searchResultContainerView.isHidden = true
    }
    
    private func setup() {
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        
        self.searchResultTableView.separatorStyle = .none
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        
        self.searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // TODO: Notification을 통해 추가될 식품의 정보가 1개 이상인 경우에만 '완료'버튼 활성화
    
    
    // MARK: @objc methods
    @objc private func textFieldDidChange(_ textField: UITextField) {
        print(textField.text)
    }
}

extension AddFoodViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddFoodCollectionViewCell", for: indexPath) as? AddFoodCollectionViewCell else { return UICollectionViewCell() }
        cell.setupLayout(title: category[indexPath.row])
        return cell
    }
}

extension AddFoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15   // TODO: 입력된 검색어를 포함한 검색 결과의 개수 반환
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodSearchResultTableViewCell", for: indexPath) as? AddFoodSearchResultTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .none
        cell.resultLabel.text = "검색어 결과 테스트"
        return cell
    }
}

extension AddFoodViewController {
    
}
