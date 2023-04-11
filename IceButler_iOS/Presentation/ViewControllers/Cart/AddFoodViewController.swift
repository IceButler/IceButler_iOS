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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.backgroundColor = .signatureLightBlue
        self.tabBarController?.tabBar.isHidden = true
        
        setupNavigationBar()
        setupLayouts()
        setupCollectionView()
    }
    
    // MARK: helper methods
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        // TODO: 장바구니 식품 추가 API 호출
    }
    
    @IBAction func didTapBackItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
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
        
    }
    
    private func setupCollectionView() {
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
    }
}

extension AddFoodViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return UICollectionViewCell()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddFoodCollectionViewCell", for: indexPath) as? AddFoodCollectionViewCell else { return UICollectionViewCell() }
        cell.setupLayout(title: category[indexPath.row])
        return cell
    }
}
