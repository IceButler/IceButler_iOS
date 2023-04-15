//
//  AuthMainViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import UIKit

class AuthMainViewController: UIViewController {
    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupObserver()
    }
    
    func setupLayout() {
        [subTitleLabel, titleLabel].forEach { label in
            label?.layer.shadowColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
            label?.layer.shadowOffset = CGSize(width: 0, height: 4)
            label?.layer.shadowOpacity = 1
        }
    }
    
    func setupObserver() {
        AuthViewModel.shared.isUserEmail {
            let authUserInfoVC = UIStoryboard(name: "AuthUserInfo", bundle: nil).instantiateViewController(identifier: "AuthUserInfoViewController") as! AuthUserInfoViewController
            
            self.navigationController?.pushViewController(authUserInfoVC, animated: true)
        }
    }
    
    
    
    @IBAction func loginWithKakao(_ sender: Any) {
        AuthViewModel.shared.loginWithKakao()
    }
    

}
