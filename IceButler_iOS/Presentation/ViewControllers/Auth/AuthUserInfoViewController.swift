//
//  AuthUserInfoViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/12.
//

import UIKit
import Photos
import BSImagePicker

class AuthUserInfoViewController: UIViewController {
    @IBOutlet weak var userImageBorderView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageAddButton: UIButton!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    @IBOutlet weak var userNickNameTextField: UITextField!
    @IBOutlet weak var userNickNameCheckButton: UIButton!
    @IBOutlet weak var userNickNameAlertLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    
    private let imagePickerController = ImagePickerController()
    
    private let nickNameMaxLength = 8
    
    private var isExistence = true
    private var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setup()
        setupLayout()
        setupNavigationBar()
        setupObserver()
    }
    
    func setup() {
        userNickNameTextField.delegate = self
    }
    
    func setupLayout() {
        userImageBorderView.layer.cornerRadius = userImageBorderView.frame.width / 2
        userImageAddButton.layer.cornerRadius = userImageAddButton.frame.width / 2
        
        userNickNameTextField.layer.cornerRadius = 10
        userNickNameCheckButton.layer.cornerRadius = 10
        joinButton.layer.cornerRadius = 30
    }
    
    func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.navigationColor
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
            statusBar?.backgroundColor = UIColor.navigationColor
        }
        
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        
        let backItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .done, target: self, action: #selector(backToScene))
        backItem.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    
    @objc private func backToScene() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupObserver() {
        AuthViewModel.shared.userEmail { userEmail in
            self.userEmailLabel.text = userEmail
        }
        
        AuthViewModel.shared.isExistence { isExistence in
            if isExistence {
                self.userNickNameTextField.backgroundColor = .unavailableRed
                self.userNickNameAlertLabel.textColor = .red
                self.userNickNameAlertLabel.text = "이미 존재하는 닉네임입니다."
            }else {
                self.userNickNameTextField.backgroundColor = .focusSkyBlue
                self.userNickNameAlertLabel.textColor = .signatureDustBlue
                self.userNickNameAlertLabel.text = "사용할 수 있는 닉네임입니다."
                self.joinButton.backgroundColor = .availableBlue
            }
            self.isExistence = isExistence
        }
        
        AuthViewModel.shared.isJoin { isJoin in
            if isJoin {
               print("회원가입 성공")
            }else {
                print("회원가입 실패")
            }
        }
    }
    
    @IBAction func addUserImage(_ sender: Any) {
        selectImage()
    }
    
    
    private func selectImage() {
        imagePickerController.settings.selection.max = 1
        imagePickerController.settings.fetch.assets.supportedMediaTypes = [.image]
        
        self.presentImagePicker(imagePickerController) { (asset) in
            
        } deselect: { (asset) in
            
        } cancel: { (assets) in
            
        } finish: { (assets) in
            let imageManager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            
            assets.forEach { asset in
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: asset,
                                          targetSize: CGSize(width: 79, height: 79),
                                          contentMode: .aspectFit,
                                          options: option) { (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                guard let newImage = UIImage(data: data!) else {return}
                
                self.profileImage = newImage
            }
            
            self.userImageView.image = self.profileImage
        }
    }
    
    
    @IBAction func checkNickName(_ sender: Any) {
        if userNickNameTextField.text != nil {
            AuthViewModel.shared.checkNickName(nickName: userNickNameTextField.text!)
        }else {
            showAlert(title: "닉네임 입력", message: "닉네임을 입력 후 중복확인을 눌러주세요.")
        }
    }
    
    
    @IBAction func join(_ sender: Any) {
        if isExistence {
            showAlert(title: "닉네임 입력", message: "닉네임 중복확인 후 회원가입을 시도해주세요.")
        }else {
            if profileImage != nil {
                AuthViewModel.shared.getUploadImageUrl(imageDir: .Profile, image: profileImage!)
            }else {
                AuthViewModel.shared.joinUser()
            }
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
}

extension AuthUserInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < nickNameMaxLength else { return false }
        if string.hasCharacters() == false {
            return false
        }
        return true
    }
}
