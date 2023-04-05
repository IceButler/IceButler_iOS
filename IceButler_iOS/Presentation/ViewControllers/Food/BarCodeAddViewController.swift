//
//  BarCodeViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/05.
//

import UIKit

class BarCodeAddViewController: UIViewController {
    
    @IBOutlet weak var barCodeView: BarCodeView!
    @IBOutlet weak var cancelButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupNavigationBar()
    }
    
    private func setup() {
        
    }
    
    private func setupLayout() {
                
        barCodeView.layer.cornerRadius = 10
        
        barCodeView.layer.borderColor = CGColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1)
        barCodeView.layer.borderWidth = 3
        
        cancelButton.backgroundColor = .white
        
        cancelButton.layer.cornerRadius = cancelButton.frame.width / 2
        
        cancelButton.layer.borderColor = CGColor(red: 170 / 255, green: 204 / 255, blue: 249 / 255, alpha: 1)
        cancelButton.layer.borderWidth = 1
    }
    
    private func setupNavigationBar() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func backToScene(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
