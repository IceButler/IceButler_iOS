//
//  EditMyFridgeViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/07.
//

import UIKit

class EditMyFridgeViewController: UIViewController {

    private var isMulti: Bool = false
    private var fridgeName: String = ""
    private var comment: String = ""
    private var members: [MemberResponseModel] = []
    private var ownerName: String = ""
    
    private var searchMember: [MemberResponseModel] = []
    private var selectedMember: [FridgeUser] = []
    private var mandatedMember: MemberResponseModel?
    

    @IBOutlet weak var typeContainerView: UIView!
    @IBOutlet weak var fridgeTypeLabel: UILabel!
    
    @IBOutlet weak var fridgeNameContainerView: UIView!
    @IBOutlet weak var fridgeNameTextField: UITextField!
    
    @IBOutlet weak var fridgeCommentContainerView: UIView!
    @IBOutlet weak var fridgeCommentTextView: UITextView!
    
    @IBOutlet weak var memberSearchContainerView: UIView!
    @IBOutlet weak var memberSearchTextField: UITextField!
    @IBOutlet weak var memberSearchResultContainerView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var memberResultTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectedMemberCollectionView: UICollectionView!
    
    @IBOutlet weak var intervalOfTableViews: NSLayoutConstraint!
    
    @IBOutlet weak var mandateSearchContainerView: UIView!
    @IBOutlet weak var mandateTextField: UITextField!
    @IBOutlet weak var mandateResultContainerView: UIView!
    @IBOutlet weak var mandateResultTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mandateTableView: UITableView!
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBAction func didTapMemberSearchButton(_ sender: UIButton) {
        // TODO: 닉네임으로 멤버 검색
        if memberSearchTextField.text?.count ?? 0 > 0 {
            FridgeViewModel.shared.searchMember(nickname: memberSearchTextField.text!, completion: {
                self.searchMember = FridgeViewModel.shared.searchMemberResults
                self.memberResultTableHeight.constant = CGFloat(50 + 44 * FridgeViewModel.shared.searchMemberResults.count)
                self.selectedMemberCollectionView.isHidden = true
                self.memberSearchResultContainerView.isHidden = false
                self.searchTableView.reloadData()
//                self.setupConstraints()
            })
        }
        else { showAlert(title: nil, message: "검색어(닉네임)를 입력해주세요!", confirmTitle: "확인") }
    }
    
    @IBAction func didTapMandateSearchButton(_ sender: UIButton) {
        // TODO: 닉네임으로 멤버 검색
        if mandateTextField.text?.count ?? 0 > 0 {
            searchMember.removeAll()
            FridgeViewModel.shared.searchMemberResults.removeAll()
            
            FridgeViewModel.shared.searchMember(nickname: mandateTextField.text!, completion: {
                self.searchMember = FridgeViewModel.shared.searchMemberResults
                self.mandateResultTableHeight.constant = CGFloat(50 + 44 * FridgeViewModel.shared.searchMemberResults.count)
                self.mandateTableView.isHidden = false
                self.mandateResultContainerView.isHidden = false
                self.mandateTableView.reloadData()
            })
        }
        else { showAlert(title: nil, message: "검색어(닉네임)를 입력해주세요!", confirmTitle: "확인") }
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        // TODO: 입력값 체크 및 냉장고 수정 요청
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayouts()
        setupSubViews()
        configure()
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
        
        let mainText = UILabel()
        mainText.text = "냉장고 수정"
        mainText.textColor = .white
        mainText.font = .systemFont(ofSize: 18, weight: .bold)
        
        let backItem = UIButton()
        backItem.setImage(UIImage(named: "backIcon"), for: .normal)
        backItem.addTarget(self, action: #selector(didTapBackItem), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: backItem),
            UIBarButtonItem(customView: mainText)
        ]
    }
    
    private func setupLayouts() {
        [
            fridgeNameTextField,
            memberSearchTextField,
            mandateTextField
        ].forEach({ textField in textField.borderStyle = .none })
        
        [
            typeContainerView,
            fridgeNameContainerView,
            fridgeCommentContainerView,
            memberSearchContainerView,
            memberSearchResultContainerView,
            mandateSearchContainerView,
            mandateResultContainerView
            
        ].forEach { btn in btn?.layer.cornerRadius = 12 }
        completeButton.layer.cornerRadius = 20
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // TODO: 각 검색 결과값을 적용한 제한으로 수정
        memberResultTableHeight.constant = CGFloat(50 + 44 * searchMember.count)
        mandateResultTableHeight.constant = CGFloat(50 + 44 * searchMember.count)
        intervalOfTableViews.constant = 40 + CGFloat(50 + 44 * searchMember.count)
    }
    
    private func setupSubViews() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.separatorStyle = .none
        searchTableView.tag = 0
        
        mandateTableView.delegate = self
        mandateTableView.dataSource = self
        mandateTableView.separatorStyle = .none
        mandateTableView.tag = 1
        
        selectedMemberCollectionView.delegate = self
        selectedMemberCollectionView.dataSource = self
        let memberCell = UINib(nibName: "MemberCollectionViewCell", bundle: nil)
        selectedMemberCollectionView.register(memberCell, forCellWithReuseIdentifier: "MemberCollectionViewCell")
    }
    
    /// 수정할 냉장고 정보로 UI 구성
    private func configure() {
        if isMulti { fridgeTypeLabel.text = "공유용" }
        else { fridgeTypeLabel.text = "가정용" }
        if fridgeName != "" {
            fridgeNameTextField.text = fridgeName
            fridgeNameContainerView.backgroundColor = .focusSkyBlue
        }
        if comment != "" {
            fridgeCommentTextView.text = comment
            fridgeCommentTextView.textColor = .black
            fridgeCommentContainerView.backgroundColor = .focusSkyBlue
        }
        mandateTextField.text = ownerName
        mandateSearchContainerView.backgroundColor = .focusSkyBlue
          
        if selectedMember.count > 0 {
            selectedMemberCollectionView.isHidden = false
            selectedMemberCollectionView.reloadData()
        }
    }
    
    private func showAlert(title: String?, message: String, confirmTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default))
        present(alert, animated: true)
    }
    
    public func setFridgeData(isMulti: Bool,
                              fridgeName: String,
                              comment: String,
                              members: [FridgeUser],
                              ownerName: String) {
        self.isMulti = isMulti
        self.fridgeName = fridgeName
        self.comment = comment
        self.ownerName = ownerName
        self.selectedMember = members
    }
    
    // MARK: @objc methods
    @objc private func didTapBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditMyFridgeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMember.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? MemberSearchTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .none
        cell.selectionStyle = .none
        cell.configure(data: self.searchMember[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt된 tableView tag -> \(tableView.tag)")
        if tableView.tag == 0 {
            selectedMember.append(FridgeUser(nickname: searchMember[indexPath.row].nickname,
                                             role: "MEMBER",
                                             profileImgUrl: searchMember[indexPath.row].profileImgUrl))
            self.memberSearchResultContainerView.isHidden = true
            self.selectedMemberCollectionView.isHidden = false
            self.selectedMemberCollectionView.reloadData()
            
        } else if tableView.tag == 1 {
            mandatedMember = searchMember[indexPath.row]
            self.mandateResultContainerView.isHidden = true
            self.mandateTextField.text = mandatedMember?.nickname
            self.mandateTextField.endEditing(true)
        }
        
    }
}

extension EditMyFridgeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedMember.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath) as? MemberCollectionViewCell else { return UICollectionViewCell() }
        cell.nicknameLabel.text = selectedMember[indexPath.row].nickname
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMember.remove(at: indexPath.row)
//        setCompleteButtonMode()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25.5 + selectedMember[indexPath.row].nickname!.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 20, height: 34)
    }
}
