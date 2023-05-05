//
//  AddFridgeViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/02.
//

import UIKit

class AddFridgeViewController: UIViewController {

    // MARK: @IBOutlet, Variables
    private var isPersonalfridge: Bool = false
    private var isMultifridge: Bool = false
    private var searchMember: [MemberResponseModel] = []
    private var selectedMemberIdx: [Int] = []
    
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
    
    // MARK: @IBAction
    @IBAction func didTapBackItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
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
        if searchTextField.text?.count ?? 0 > 0 {
            FridgeViewModel.shared.searchMember(nickname: searchTextField.text!, completion: {
                self.tableViewHeight.constant = CGFloat(50 + 44 * FridgeViewModel.shared.searchMemberResults.count)
                self.searchResultContainerView.isHidden = false
                self.memberSearchTableView.reloadData()
            })
        }
        else { showAlert(title: nil, message: "검색어(닉네임)를 입력해주세요!", confirmTitle: "확인") }
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        let addResult = FridgeViewModel.shared.requestAddFridge(name: fridgeNameTextField.text!,
                                                comment: fridgeDetailTextView.text!,
                                                members: selectedMemberIdx)
        
        if addResult { showAlert(title: nil, message: "냉장고를 성공적으로 추가하였습니다!", confirmTitle: "확인") }
        else { showAlert(title: nil, message: "냉장고 추가에 실패하였습니다", confirmTitle: "확인") }
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
        if checkFridgeType()
            && checkFridgeName()
            && checkFridgeDetail()
            && checkFridgeMember() { return true }
        else { return false }
    }
    
    
    // MARK: @objc methods
    @objc func textFieldDidChange(_ textField: UITextField) {
        if isEmptyInputs() {
            completeButton.backgroundColor = .availableBlue
            completeButton.isEnabled = true
        } else {
            completeButton.backgroundColor = .systemGray4
            completeButton.isEnabled = false
        }
        
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
    
    /// 냉장고 세부사항 입력 여부
    private func checkFridgeDetail() -> Bool {
        if (fridgeDetailTextView.text.count > 0)
            && (fridgeDetailTextView.text != "200자 이내로 작성해주세요.") { return true }
        else { return false }
    }
    
    /// 냉장고 멤버 추가 여부
    private func checkFridgeMember() -> Bool {
        return (selectedMemberIdx.count > 0) ? true : false
    }
}

// MARK: extensions for delegate, ...
extension AddFridgeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if isEmptyInputs() {
            completeButton.backgroundColor = .availableBlue
            completeButton.isEnabled = true
        } else {
            completeButton.backgroundColor = .systemGray4
            completeButton.isEnabled = false
        }
        
        if textView.text.count > 0 {
            detailContainerView.backgroundColor = .focusTableViewSkyBlue
        } else {
            detailContainerView.backgroundColor = .systemGray6
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
        selectedMemberIdx.append(FridgeViewModel.shared.searchMemberResults[indexPath.row].userIdx)
        self.searchResultContainerView.isHidden = true
    }
}
