//
//  FridgeViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/05.
//

import UIKit

class FridgeViewController: UIViewController {

    @IBOutlet weak var foodAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func setup() {
        
    }
    
    
    func setupLayout() {
        self.view.backgroundColor = .white
        
        foodAddButton.backgroundColor = .signatureDeepBlue
        
        foodAddButton.layer.cornerRadius = foodAddButton.frame.width / 2
        foodAddButton.layer.shadowColor = CGColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        foodAddButton.layer.shadowOpacity = 1
        foodAddButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    @IBAction func foodAdd(_ sender: Any) {
        foodAddButton.isHidden = true
        
        let foodAddVC = UIStoryboard(name: "FoodAddSelect", bundle: nil).instantiateViewController(identifier: "FoodAddSelectViewController") as! FoodAddSelectViewController
        foodAddVC.setupDelegate(delegate: self)
        
        foodAddVC.modalTransitionStyle = .crossDissolve
        foodAddVC.modalPresentationStyle = .overFullScreen
        
        self.present(foodAddVC, animated: true)
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
}

extension FridgeViewController: FoodAddDelegate {
    func moveToFoodAddSelect() {
        foodAddButton.isHidden = true
        
        let foodAddVC = UIStoryboard(name: "FoodAddSelect", bundle: nil).instantiateViewController(identifier: "FoodAddSelectViewController") as! FoodAddSelectViewController
        foodAddVC.setupDelegate(delegate: self)
        
        foodAddVC.modalTransitionStyle = .crossDissolve
        foodAddVC.modalPresentationStyle = .overFullScreen
        
        self.present(foodAddVC, animated: true)
    }
}
