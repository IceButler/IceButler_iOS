//
//  MyPageViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/12.
//

import UIKit

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
    
    private func configure() {
        // TODO: 유저의 프로필 사진, 닉네임, 이메일 설정
    }
    
    private func setupNavigationBar() {
        /// setting status bar background color
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.signatureLightBlue
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
            statusBar?.backgroundColor = UIColor.red
        }
        
        self.navigationController?.navigationBar.backgroundColor = .signatureLightBlue
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
        print("프로필 편집 화면으로 이동")
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
                print("로그아웃 팝업 띄우기")
            case 1:
                print("회원탈퇴 팝업 띄우기")
            default: return
            }
        case 3:
            switch indexPath.row {
            case 0:
                // TODO: 약관안내 화면으로 전환
                print("약관안내 화면으로 전환")
            case 1:
                // TODO: 개인정보처리방침 화면으로 전환
                print("개인정보처리방침 화면으로 전환")
            default: return
            }
        default: return
        }
    }
    
}
