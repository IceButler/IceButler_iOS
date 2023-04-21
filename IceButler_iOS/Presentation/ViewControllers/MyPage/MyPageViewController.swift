//
//  MyPageViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/12.
//

import UIKit
import Kingfisher

class MyPageViewController: UIViewController {
    
    private let sectionList = ["My", "내 결제", "계정 설정", "앱 정보"]
    private let menuList = [
        ["마이 냉장고", "마이 레시피"],
        ["Pro 버전"],
        ["로그아웃", "회원탈퇴"],
        ["약관 안내", "개인 정보 처리 방침"]
    ]

    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupNavigationBar()
        setupTableView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AuthViewModel.shared.isModify = false
    }
    
    private func configure() {
        UserViewModel.shared.getUserInfo()
        
        
        
        UserViewModel.shared.userInfo { user in
            if let imageUrlString = user.profileImage {
                if let imageUrl = URL(string: imageUrlString) {
                    self.profileImgView.kf.setImage(with: imageUrl)
                }
            }
            self.nicknameLabel.text = user.nickname
            self.emailLabel.text = user.email
        }
    }
    
    private func setupNavigationBar() {
        /// setting status bar background color
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupLayout() {
        profileContainerView.layer.cornerRadius = 12
        profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
        editProfileButton.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 12
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    @IBAction func didTapEditProfileButton(_ sender: UIButton) {
        // TODO: 프로필 편집 화면으로 이동
        let authUserInfoVC = UIStoryboard(name: "AuthUserInfo", bundle: nil).instantiateViewController(identifier: "AuthUserInfoViewController") as! AuthUserInfoViewController
        
        authUserInfoVC.setEditMode(mode: .Modify)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(authUserInfoVC, animated: true)
    }
    
    private func showPolicyWebVC(policyType: PolicyType) {
        guard let policyWebViewController = storyboard!.instantiateViewController(withIdentifier: "PolicyWebViewController") as? PolicyWebViewController else { return }
        
        switch policyType {
        case .tosGuide: policyWebViewController.setPolicyType(policyType: policyType.rawValue)
            policyWebViewController.setUrl(url: PolicyUrl.tosGuide.rawValue)
        case .privacyPolicy: policyWebViewController.setPolicyType(policyType: policyType.rawValue)
            policyWebViewController.setUrl(url: PolicyUrl.privacyPolicy.rawValue)
        }
        
        self.navigationController?.pushViewController(policyWebViewController, animated: true)
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return self.sectionList.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.menuList[section].count }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return self.sectionList[section] }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MypageMenuTableViewCell", for: indexPath) as? MypageMenuTableViewCell else { return UITableViewCell() }
        cell.menuNameLabel.text = self.menuList[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 섹션/행 별로 화면 전환 구분
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("마이 냉장고 화면으로 전환")
            case 1:
                print("마이 레시피 화면으로 전환")
            default: return
            }
        case 1:
            print("Pro 결제 화면으로 전환")
        case 2:
            switch indexPath.row {
            case 0:
                let alertVC = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(identifier: "AlertViewController") as! AlertViewController
                alertVC.configure(title: "로그아웃", content: "로그아웃 하시겠습니까?", leftButtonTitle: "취소", righttButtonTitle: "확인") {
                    AuthViewModel.shared.logout()
                } leftCompletion: {
                }
                alertVC.modalPresentationStyle = .overFullScreen
                
                self.present(alertVC, animated: true)

            case 1:
                print("회원탈퇴 팝업 띄우기")
            default: return
            }
        case 3:
            switch indexPath.row {
            case 0:
                showPolicyWebVC(policyType: .tosGuide)
            case 1:
                showPolicyWebVC(policyType: .privacyPolicy)
            default: return
            }
        default: return
        }
    }
    
}
