//
//  AddFridgeViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/02.
//

import UIKit
import JGProgressHUD

class AddFridgeViewController: UIViewController {

    // MARK: @IBOutlet, Variables    
    private var isPersonalfridge: Bool = false
    private var isMultifridge: Bool = false
    private var searchMember: [FridgeUser] = []
    private var selectedMember: [FridgeUser] = []
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var fridgeButton: UIButton!
    @IBOutlet weak var multiFridgeButton: UIButton!
    
    @IBOutlet weak var fridgeInfoLabel: UILabel!
    @IBOutlet weak var multiFridgeInfoLabel: UILabel!
    
    @IBOutlet weak var nameFieldContainer: UIView!
    @IBOutlet weak var fridgeNameTextField: UITextField!
    
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var fridgeDetailTextView: UITextView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var searchResultContainerView: UIView!
    @IBOutlet weak var memberSearchTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var memberCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    
    // MARK: @IBAction
    @IBAction func didTapBackItem(_ sender: UIBarButtonItem) { dismiss(animated: true) }
    
    @IBAction func didTapFridgeButton(_ sender: UIButton) {
        isPersonalfridge = true
        isMultifridge = false
        
        fridgeInfoLabel.isHidden = false
        multiFridgeInfoLabel.isHidden = true
        
        fridgeButton.backgroundColor = .availableBlue
        multiFridgeButton.backgroundColor = .systemGray4
    }
    
    @IBAction func didTapMultiFridgeButton(_ sender: UIButton) {
        isPersonalfridge = false
        isMultifridge = true
        
        fridgeInfoLabel.isHidden = true
        multiFridgeInfoLabel.isHidden = false
        
        multiFridgeButton.backgroundColor = .availableBlue
        fridgeButton.backgroundColor = .systemGray4
    }
    
    @IBAction func didTapMemberSearchButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            if self.searchTextField.text?.count ?? 0 > 0 {
                FridgeViewModel.shared.searchMember(nickname: self.searchTextField.text!, completion: {
                    self.searchMember = FridgeViewModel.shared.searchMemberResults
                    self.tableViewHeight.constant = CGFloat(50 + 44 * FridgeViewModel.shared.searchMemberResults.count)
                    self.memberCollectionView.isHidden = true
                    self.searchResultContainerView.isHidden = false
                    self.memberSearchTableView.reloadData()
                })
            }
            else { self.showAlert(title: nil, message: "검색어(닉네임)를 입력해주세요!", confirmTitle: "확인") }
            
            hud.dismiss(animated: true)
        }
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        if fridgeDetailTextView.text.count > 200 {
            showAlert(title: "냉장고 추가 실패", message: "200자가 넘는 코멘트를 가질 수 없습니다.", confirmTitle: "확인")
            return
        }
        
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            var memberIdx:[Int] = []
            self.selectedMember.forEach { member in memberIdx.append(member.userIdx) }
            
            FridgeViewModel.shared.requestAddFridge(isMulti: self.isMultifridge,
                                                    name: self.fridgeNameTextField.text!,
                                                    comment: self.fridgeDetailTextView.text!,
                                                    members: memberIdx,
                                                    completion: { [weak self] result in
                if result {
                    self?.dismiss(animated: true)
                    FridgeViewModel.shared.getAllFoodList(fridgeIdx: APIManger.shared.getFridgeIdx())
                }
                else { self?.showAlert(title: nil, message: "냉장고 추가에 실패하였습니다", confirmTitle: "확인") }
            })
            
            hud.dismiss(animated: true)
        }
    }
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationBar()
        setupLayouts()
        setupTextInputTargets()
    }
    
    // MARK: Helper Methods
    private func setup() {
        memberSearchTableView.delegate = self
        memberSearchTableView.dataSource = self
        memberSearchTableView.separatorStyle = .none
        
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        let memberCell = UINib(nibName: "MemberCollectionViewCell", bundle: nil)
        memberCollectionView.register(memberCell, forCellWithReuseIdentifier: "MemberCollectionViewCell")
    }
    
    private func setupNavigationBar() {
        /// setting status bar background color
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height + 5
            
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
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
    }
    
    private func setupLayouts() {
        navigationBar.barTintColor = .navigationColor
        [
            fridgeNameTextField,
            searchTextField
            
        ].forEach({ textField in textField.borderStyle = .none })
        
        [
            fridgeButton,
            multiFridgeButton,
            nameFieldContainer,
            detailContainerView,
            searchResultContainerView,
            memberSearchTableView,
            completeButton
            
        ].forEach { btn in btn?.layer.cornerRadius = 12 }
        searchContainerView.layer.cornerRadius = 20
    }
    
    private func setupTextInputTargets() {
        fridgeNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fridgeDetailTextView.delegate = self
    }
    
    private func showAlert(title: String?, message: String, confirmTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default))
        present(alert, animated: true)
    }
    
    private func isEmptyInputs() -> Bool {
        if checkFridgeType() && checkFridgeName() { return true }
        else { return false }
    }
    
    private func isAlreadyAddedMember(member: FridgeUser) -> Bool {
        var isAlready = false
        selectedMember.forEach { m in if member.userIdx == m.userIdx { isAlready = true } }
        return isAlready
    }
    
    private func hiddenSearchResultView() {
        self.searchResultContainerView.isHidden = true
        self.memberCollectionView.isHidden = false
        self.memberCollectionView.reloadData()
    }
    
    // MARK: @objc methods
    @objc func textFieldDidChange(_ textField: UITextField) {
        setCompleteButtonMode()
        
        if textField.text?.count ?? 0 > 0 {
            
            if textField == fridgeNameTextField {
                nameFieldContainer.backgroundColor = .focusTableViewSkyBlue
            } else if textField == searchTextField {
                searchContainerView.backgroundColor = .focusTableViewSkyBlue
            }
            
        } else {
            
            if textField == fridgeNameTextField {
                nameFieldContainer.backgroundColor = .systemGray6
            } else if textField == searchTextField {
                searchContainerView.backgroundColor = .systemGray6
            }
            
        }
    }
}

// MARK: check methods
extension AddFridgeViewController {

    /// 가정용,공용 선택 여부 확인
    private func checkFridgeType() -> Bool {
        if isPersonalfridge || isMultifridge { return true }
        else { return false }
    }
    
    /// 냉장고 이름 입력 여부
    private func checkFridgeName() -> Bool {
        if fridgeNameTextField.text?.count ?? 0 > 0 { return true }
        else { return false }
    }
    
    /// 완료 버튼 활성/비활성 설정
    private func setCompleteButtonMode() {
        if isEmptyInputs() {
            completeButton.backgroundColor = .availableBlue
            completeButton.isEnabled = true
        } else {
            completeButton.backgroundColor = .systemGray4
            completeButton.isEnabled = false
        }
    }
}

// MARK: extensions for delegate, ...
extension AddFridgeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
        detailContainerView.backgroundColor = .notInputColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setCompleteButtonMode()
        
        if textView.text.count == 0 {
            detailContainerView.backgroundColor = .notInputColor
        } else if textView.text.count > 200 {
            detailContainerView.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 153/255, alpha: 1)
            self.view.makeToast("200자 이내의 코멘트를 입력해주세요!", duration: 1.0, position: .center)
        } else {
            detailContainerView.backgroundColor = .focusTableViewSkyBlue
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "200자 이내로 작성해주세요."
            textView.textColor = .lightGray
        }
    }
}

extension AddFridgeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FridgeViewModel.shared.searchMemberResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberSearchTableViewCell", for: indexPath) as? MemberSearchTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .none
        cell.selectionStyle = .none
        cell.configure(data: FridgeViewModel.shared.searchMemberResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isAlreadyAddedMember(member: searchMember[indexPath.row]) {
            showAlert(title: nil, message: "이미 추가된 멤버입니다!", confirmTitle: "확인")
            hiddenSearchResultView()
            
        } else {
            UserService().getUserInfo { [weak self] userInfo in
                if userInfo.userIdx == self?.searchMember[indexPath.row].userIdx {
                    self?.showAlert(title: "멤버 추가 실패", message: "본인을 냉장고 멤버로 추가할 수 없습니다.", confirmTitle: "확인")
                    self?.hiddenSearchResultView()
                    
                } else {
                    self?.selectedMember.append((self?.searchMember[indexPath.row])!)
                    self?.hiddenSearchResultView()
                }
            }
        }
        
    }
}

extension AddFridgeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        setCompleteButtonMode()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25.5 + selectedMember[indexPath.row].nickname!.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 20, height: 34)
    }
}
