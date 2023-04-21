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
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageAddButton: UIButton!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    @IBOutlet weak var userNicknameTextField: UITextField!
    @IBOutlet weak var userNicknameCheckButton: UIButton!
    @IBOutlet weak var userNicknameAlertLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    
    private let imagePickerController = ImagePickerController()
    
    private let nicknameMaxLength = 8
    
    private var isExistence = true
    private var profileImage: UIImage?
    
    private var mode: ProfileEditMode = .Join
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setup()
        setupLayout()
        setupNavigationBar()
        setupObserver()
    }
    
    func setup() {
        userNicknameTextField.delegate = self
    }
    
    func setupLayout() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageAddButton.layer.cornerRadius = userImageAddButton.frame.width / 2
        
        userNicknameTextField.layer.cornerRadius = 10
        userNicknameCheckButton.layer.cornerRadius = 10
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
        
        if mode == .Modify {
            let titleLabel = UILabel()
            titleLabel.text = "프로필 편집"
            titleLabel.textAlignment = .left
            titleLabel.font = UIFont.systemFont(ofSize: 18)
            titleLabel.textColor = .white
            titleLabel.sizeToFit()
            
            let titleItem = UIBarButtonItem(customView: titleLabel)
            
            self.navigationItem.leftBarButtonItems = [backItem, titleItem]
        }else {
            self.navigationItem.leftBarButtonItem = backItem
        }
        
       
    }
    
    
    @objc private func backToScene() {
        navigationController?.popViewController(animated: true)
    }
    
    func setEditMode(mode: ProfileEditMode) {
        self.mode = mode
    }
    
    
    func setupObserver() {
        if mode == .Modify {
            UserViewModel.shared.userInfo { user in
                if let imageUrlString = user.profileImage {
                    if let imageUrl = URL(string: imageUrlString) {
                        self.userImageView.kf.setImage(with: imageUrl)
                    }
                }
                self.userNicknameTextField.text = user.nickname
                self.userEmailLabel.text = user.email
            }
            
            AuthViewModel.shared.isModify { isModify in
                if isModify == true {
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            AuthViewModel.shared.userEmail { userEmail in
                self.userEmailLabel.text = userEmail
            }
            
            AuthViewModel.shared.isJoin { isJoin in
                if isJoin == false {
                    self.showAlert(title: "회원가입 실패", message: "회원가입에 실패하였습니다. 다시 시도해주세요.")
                }
            }
        }
        
        AuthViewModel.shared.isExistence { isExistence in
            if isExistence {
                self.userNicknameTextField.backgroundColor = .unavailableRed
                self.userNicknameAlertLabel.textColor = .red
                self.userNicknameAlertLabel.text = "이미 존재하는 닉네임입니다."
            }else {
                self.userNicknameTextField.backgroundColor = .focusSkyBlue
                self.userNicknameAlertLabel.textColor = .textDeepBlue
                self.userNicknameAlertLabel.text = "사용할 수 있는 닉네임입니다."
                self.joinButton.backgroundColor = .availableBlue
            }
            self.isExistence = isExistence
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
        if userNicknameTextField.text != nil {
            AuthViewModel.shared.checkNickname(nickname: userNicknameTextField.text!)
        }else {
            showAlert(title: "닉네임 입력", message: "닉네임을 입력 후 중복확인을 눌러주세요.")
        }
    }
    
    
    @IBAction func join(_ sender: Any) {
        if isExistence {
            showAlert(title: "닉네임 입력", message: "닉네임 중복확인 후 프로필 편집을 시도해주세요.")
        }else {
            if profileImage != nil {
                AuthViewModel.shared.getUploadImageUrl(imageDir: .Profile, image: profileImage!, mode: mode)
            }else {
                if mode == .Join {
                    AuthViewModel.shared.joinUser()
                }else {
                    AuthViewModel.shared.modifyUser()
                }
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
        guard textField.text!.count < nicknameMaxLength else { return false }
        if string.hasCharacters() == false {
            return false
        }
        return true
    }
}
