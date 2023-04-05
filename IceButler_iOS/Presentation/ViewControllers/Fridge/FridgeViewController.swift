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
        
        foodAddButton.layer.cornerRadius = foodAddButton.frame.width / 2
        foodAddButton.backgroundColor = .signatureDeepBlue
    }

    @IBAction func foodAdd(_ sender: Any) {
        let barCodeAddVC = UIStoryboard(name: "BarCodeAdd", bundle: nil).instantiateViewController(identifier: "BarCodeAddViewController") as! BarCodeAddViewController
        
        barCodeAddVC.modalTransitionStyle = .coverVertical
        barCodeAddVC.modalPresentationStyle = .fullScreen
        
        self.present(barCodeAddVC, animated: true)
    }
    

}
