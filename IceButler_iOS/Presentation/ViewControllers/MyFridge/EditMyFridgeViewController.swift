//
//  EditMyFridgeViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/07.
//

import UIKit
import JGProgressHUD
import Toast_Swift

class EditMyFridgeViewController: UIViewController {

    private var isMulti: Bool = false
    private var fridgeName: String = ""
    private var comment: String = ""
    private var members: [FridgeUser] = []
    private var ownerName: String = ""
    
    private var fridgeIdx: Int = -1
    private var searchMember: [FridgeUser] = []
    private var selectedMember: [FridgeUser] = []
    private var mandatedMember: FridgeUser?
    

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
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            if self.memberSearchTextField.text?.count ?? 0 > 0 {
                self.searchMember.removeAll()
                FridgeViewModel.shared.searchMemberResults.removeAll()

                FridgeViewModel.shared.searchMember(nickname: self.memberSearchTextField.text!, completion: {
                    self.searchMember = FridgeViewModel.shared.searchMemberResults
                    if self.searchMember.count > 0 {
                        self.memberResultTableHeight.constant = CGFloat(50 + 44 * FridgeViewModel.shared.searchMemberResults.count)
                        self.selectedMemberCollectionView.isHidden = true
                        self.memberSearchResultContainerView.isHidden = false
                        self.searchTableView.reloadData()
                    } else {
                        self.view.makeToast("멤버 검색 결과가 없습니다!", duration: 1.0, position: .center)
                        self.memberSearchResultContainerView.isHidden = true
                    }
                })
            }
            else { self.showAlert(title: nil, message: "검색어(닉네임)를 입력해주세요!", confirmTitle: "확인") }
            
            hud.dismiss(animated: true)
        }
    }
    
    @IBAction func didTapMandateSearchButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            if self.mandateTextField.text?.count ?? 0 > 0 {
                self.searchMember.removeAll()
                FridgeViewModel.shared.searchMemberResults.removeAll()
                
                FridgeViewModel.shared.searchMember(nickname: self.mandateTextField.text!, completion: {
                    self.searchMember = FridgeViewModel.shared.searchMemberResults
                    if self.searchMember.count > 0 {
                        self.mandateResultTableHeight.constant = CGFloat(50 + 44 * FridgeViewModel.shared.searchMemberResults.count)
                        self.mandateResultContainerView.isHidden = false
                        self.mandateTableView.reloadData()
                        
                    } else {
                        self.view.makeToast("멤버 검색 결과가 없습니다!", duration: 1.0, position: .center)
                        self.mandateResultContainerView.isHidden = true
                    }
                })
            }
            else { self.showAlert(title: nil, message: "검색어(닉네임)를 입력해주세요!", confirmTitle: "확인") }
            
            hud.dismiss(animated: true)
        }
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        if let name = fridgeNameTextField.text,
           selectedMember.count > 0,
           let newOwner = mandatedMember {
            
            if name.count > 20 {
                showAlert(title: "냉장고 수정 실패", message: "20자가 넘는 이름으로 수정할 수 없습니다.", confirmTitle: "확인")
                return
            }
            
            if fridgeCommentTextView.text.count > 200 {
                showAlert(title: "냉장고 수정 실패", message: "200자가 넘는 코멘트로 수정할 수 없습니다.", confirmTitle: "확인")
                return
            }
            
            var memberIdxs:[UserIndexModel] = []
            selectedMember.forEach { member in memberIdxs.append(UserIndexModel(userIdx: member.userIdx)) }
            
            let param = EditedFridgeRequestModel(fridgeName: name,
                                                 fridgeComment: (fridgeCommentTextView.text == "200자 이내로 작성해주세요.") ? "" : fridgeCommentTextView.text,
                                                 members: memberIdxs,
                                                 newOwnerIdx: newOwner.userIdx)
            
            var urlStr = ""
            if isMulti { urlStr = "/multiFridges/\(fridgeIdx)" }
            else { urlStr = "/fridges/\(fridgeIdx)" }
            
            APIManger.shared.patchData(urlEndpointString: urlStr,
                                       responseDataType: EditedFridgeRequestModel.self,
                                       requestDataType: EditedFridgeRequestModel.self,
                                       parameter: param,
                                       completionHandler: { [weak self] response in
                switch response.statusCode {
                case 200: self?.navigationController?.popViewController(animated: true)
                default: self?.showAlert(title: "마이냉장고 수정 실패", message: response.description ?? "", confirmTitle: "확인")
                }
            })
            
        } else {
            showAlert(title: nil, message: "모든 정보를 입력해주세요!", confirmTitle: "확인")
        }
    }
    
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayouts()
        setupSubViews()
        configure()
    }
    
    // MARK: Helper Methods
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
            statusBar?.backgroundColor = UIColor.red
        }
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.tabBarController?.tabBar.isHidden = false
        
        let mainText = UILabel()
        mainText.text = "냉장고 수정"
        mainText.textColor = .white
        mainText.font = .systemFont(ofSize: 18, weight: .bold)
        
        let backItem = UIButton()
        backItem.setImage(UIImage(named: "backIcon"), for: .normal)
        backItem.addTarget(self, action: #selector(didTapBackItem), for: .touchUpInside)
        backItem.frame = CGRect(x: 0, y: 0, width: 35, height: 20)
        
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: backItem),
            UIBarButtonItem(customView: mainText)
        ]
        
        self.tabBarController?.tabBar.isHidden = true
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
        completeButton.layer.cornerRadius = 25
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        /// 각 검색 결과값을 적용한 제한으로 수정
        memberResultTableHeight.constant = CGFloat(50 + 44 * searchMember.count)
        mandateResultTableHeight.constant = CGFloat(50 + 44 * searchMember.count)
        intervalOfTableViews.constant = 40 + CGFloat(50 + 44 * searchMember.count)
    }
    
    private func setupSubViews() {
        /// TableView
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.separatorStyle = .none
        searchTableView.tag = 0
        
        mandateTableView.delegate = self
        mandateTableView.dataSource = self
        mandateTableView.separatorStyle = .none
        mandateTableView.tag = 1
        
        /// CollectionView
        selectedMemberCollectionView.delegate = self
        selectedMemberCollectionView.dataSource = self
        let memberCell = UINib(nibName: "MemberCollectionViewCell", bundle: nil)
        selectedMemberCollectionView.register(memberCell, forCellWithReuseIdentifier: "MemberCollectionViewCell")
        
        /// TextField, TextView
        fridgeCommentTextView.delegate = self
        fridgeNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        memberSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mandateTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    
    private func isAlreadyAddedMember(member: FridgeUser) -> Bool {
        var isAlready = false
        selectedMember.forEach { m in if member.userIdx == m.userIdx { isAlready = true } }
        return isAlready
    }
    
    public func setFridgeIdx(index: Int) { fridgeIdx = index }
    
    public func setFridgeData(isMulti: Bool,
                              fridgeName: String,
                              comment: String,
                              members: [FridgeUser],
                              owner: FridgeUser) {
        self.isMulti = isMulti
        self.fridgeName = fridgeName
        self.comment = comment
        self.ownerName = owner.nickname!
        self.selectedMember = members
        self.mandatedMember = owner
    }
    
    // MARK: @objc methods
    @objc private func didTapBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        if textField.text?.count ?? 0 > 0 {
            
            switch textField {
            case fridgeNameTextField:
                if let name = fridgeNameTextField.text {
                    if name.count > 20 {
                        fridgeNameContainerView.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 219/255, alpha: 0.6)
                        self.view.makeToast("20자 이내의 이름을 입력해주세요!", duration: 1.0, position: .center)
                    } else {
                        fridgeNameContainerView.backgroundColor = .focusTableViewSkyBlue
                    }
                }
                
            case memberSearchTextField:
                memberSearchResultContainerView.isHidden = true
                selectedMemberCollectionView.isHidden = false
                memberSearchContainerView.backgroundColor = .focusTableViewSkyBlue
            case mandateTextField:
                mandateResultContainerView.isHidden = true
                mandateSearchContainerView.backgroundColor = .focusTableViewSkyBlue
            default: return
            }
            
        } else {

            switch textField {
            case fridgeNameTextField:
                fridgeNameContainerView.backgroundColor = .notInputColor
            case memberSearchTextField:
                memberSearchContainerView.backgroundColor = .notInputColor
            case mandateTextField:
                mandateSearchContainerView.backgroundColor = .notInputColor
            default: return
            }
        }
    }
}

extension EditMyFridgeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMember.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? MemberSearchTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .none
            cell.selectionStyle = .none
            cell.configure(data: self.searchMember[indexPath.row])
            return cell
            
        } else if tableView.tag == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MandateTableViewCell", for: indexPath) as? MemberSearchTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .none
            cell.selectionStyle = .none
            cell.configure(data: self.searchMember[indexPath.row])
            return cell
        }
        
       return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            if !self.isAlreadyAddedMember(member: searchMember[indexPath.row]) {
                selectedMember.append(FridgeUser(nickname: searchMember[indexPath.row].nickname,
                                                 role: "MEMBER",
                                                 profileImgUrl: searchMember[indexPath.row].profileImgUrl,
                                                 userIdx: searchMember[indexPath.row].userIdx))
            } else {
                self.showAlert(title: nil, message: "이미 추가된 멤버입니다!", confirmTitle: "확인")
            }
            
            
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
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25.5 + selectedMember[indexPath.row].nickname!.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 20, height: 34)
    }
}

// MARK: extensions for delegate, ...
extension EditMyFridgeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
        fridgeCommentContainerView.backgroundColor = .notInputColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            fridgeCommentContainerView.backgroundColor = .notInputColor
        } else if textView.text.count > 200 {
            fridgeCommentContainerView.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 219/255, alpha: 0.6)
            self.view.makeToast("200자 이내의 코멘트를 입력해주세요!", duration: 1.0, position: .center)
        } else {
            fridgeCommentContainerView.backgroundColor = .focusTableViewSkyBlue
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "200자 이내로 작성해주세요."
            textView.textColor = .lightGray
            fridgeCommentContainerView.backgroundColor = .notInputColor
        }
    }
}
