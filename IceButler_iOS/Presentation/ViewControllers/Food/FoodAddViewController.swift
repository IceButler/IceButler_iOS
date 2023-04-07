//
//  FoodAddViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/06.
//

import UIKit

protocol FoodAddDelegate: AnyObject {
    func moveToFoodAddSelect()
}

class FoodAddViewController: UIViewController {
    
    private var delegate: FoodAddDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavgationBar()
    }
    
    private func setup() {
        
    }
    
    private func setupLayout() {
        
    }
    
    private func setupNavgationBar() {
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        
        let backItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .done, target: self, action: #selector(backToScene))
        backItem.tintColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "식품 추가"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [backItem, titleItem]
    }
    
    @objc private func backToScene() {
        navigationController?.popViewController(animated: true)
        delegate?.moveToFoodAddSelect()
    }
    
    func setDelegate(delegate: FoodAddDelegate) {
        self.delegate = delegate
    }

}
