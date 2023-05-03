//
//  AuthMainViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import UIKit
import Kingfisher
import SnapKit
import AuthenticationServices

class AuthMainViewController: UIViewController {
    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var kakaoLoginButton: UIButton!
    private var appleLoginButton: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAppleLoginButton()
        setupLayout()
        setupObserver()
    }
    
    private func setAppleLoginButton() {
        appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleLoginButton.addTarget(self, action: #selector(loginWithApple), for: .touchUpInside)
        self.view.addSubview(appleLoginButton)
    }
    
    private func setupLayout() {
        [subTitleLabel, titleLabel].forEach { label in
            label?.layer.shadowColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
            label?.layer.shadowOffset = CGSize(width: 0, height: 4)
            label?.layer.shadowOpacity = 1
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
    }
    
    private func setupObserver() {
        AuthViewModel.shared.isUserEmail {
            let authUserInfoVC = UIStoryboard(name: "AuthUserInfo", bundle: nil).instantiateViewController(identifier: "AuthUserInfoViewController") as! AuthUserInfoViewController
            
            authUserInfoVC.setEditMode(mode: .Join)
            
            self.navigationController?.pushViewController(authUserInfoVC, animated: true)
        }
    }
    
    
    
    @IBAction func loginWithKakao(_ sender: Any) {
        AuthViewModel.shared.loginWithKakao()
    }
    
    @objc func loginWithApple() {
        AuthViewModel.shared.loginWithApple { request in
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = AuthViewModel.shared as! any ASAuthorizationControllerDelegate
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }

    
}

extension AuthMainViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
