//
//  AuthUserInfoViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import UIKit

class AuthUserInfoViewController: UIViewController {

    @IBOutlet weak var userImageBorderView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageAddView: UIButton!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    @IBOutlet weak var userNickNameTextField: UITextField!
    @IBOutlet weak var userNickNameCheckButton: UIButton!
    @IBOutlet weak var userNickNameAlertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setup() {
        
    }
    
    func setupLayout() {
        userImageBorderView.layer.cornerRadius = userImageBorderView.frame.width / 2
        userImageAddView.layer.cornerRadius = userImageView.frame.width / 2
        
        userNickNameTextField.layer.cornerRadius = 10
        userNickNameCheckButton.layer.cornerRadius = 10
    }
    
    func setupObserver() {
        AuthViewModel.shared.userEmail { userEmail in
            self.userEmailLabel.text = userEmail
        }
        
        
    }
    

}
