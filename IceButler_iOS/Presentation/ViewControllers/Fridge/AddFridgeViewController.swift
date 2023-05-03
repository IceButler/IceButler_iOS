//
//  AddFridgeViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/02.
//

import UIKit

class AddFridgeViewController: UIViewController {

    // MARK: @IBOutlet, Variables
    @IBOutlet weak var fridgeButton: UIButton!
    @IBOutlet weak var multiFridgeButton: UIButton!
    
    @IBOutlet weak var fridgeInfoLabel: UILabel!
    @IBOutlet weak var multiFridgeInfoLabel: UILabel!
    
    @IBOutlet weak var nameFieldContainer: UIView!
    @IBOutlet weak var fridgeNameTextField: UITextField!
    @IBOutlet weak var fridgeDetailTextView: UITextView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var searchResultContainerView: UIView!
    @IBOutlet weak var memberSearchTableView: UITableView!
    
    
    // MARK: @IBAction
    @IBAction func didTapFridgeButton(_ sender: UIButton) {
        fridgeInfoLabel.isHidden = false
        multiFridgeInfoLabel.isHidden = true
        
        fridgeButton.backgroundColor = .availableBlue
        multiFridgeButton.backgroundColor = .systemGray4
    }
    
    @IBAction func didTapMultiFridgeButton(_ sender: UIButton) {
        fridgeInfoLabel.isHidden = true
        multiFridgeInfoLabel.isHidden = false
        
        multiFridgeButton.backgroundColor = .availableBlue
        fridgeButton.backgroundColor = .systemGray4
    }
    
    @IBAction func didTapMemberSearchButton(_ sender: UIButton) {
        // TODO: searchTextField에 입력된 닉네임으로 멤버 검색 요청
        if searchTextField.text?.count ?? 0 > 0 {
            print("입력된 검색어(닉네임) --> \(searchTextField.text!)")
            searchResultContainerView.isHidden = false
        }
        else { showAlert(title: nil, message: "검색어(닉네임)를 입력해주세요!", confirmTitle: "확인") }
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        // TODO: 입력값이 모두 존재하는지 확인 (미입력이 존재한다면 Alert 띄우기), 냉장고 추가 요청
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
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        
        // left item
        let mainText = UILabel()
        mainText.text = "냉장고 추가"
        mainText.textColor = .white
        mainText.font = .systemFont(ofSize: 18, weight: .bold)
        
        let backItem = UIButton()
        backItem.setImage(UIImage(named: "backIcon"), for: .normal)
        backItem.frame = CGRect(x: 0, y: 0, width: 30, height: backItem.frame.height)
        backItem.addTarget(self, action: #selector(didTapBackItem), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: backItem),
            UIBarButtonItem(customView: mainText)
        ]
    }
    
    private func setupLayouts() {
        [
            fridgeNameTextField,
            searchTextField
            
        ].forEach({ textField in textField.borderStyle = .none })
        
        [
            fridgeButton,
            multiFridgeButton,
            nameFieldContainer,
            fridgeDetailTextView,
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
    
    
    // MARK: @objc methods
    @objc private func didTapBackItem() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
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

extension AddFridgeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            textView.backgroundColor = .focusTableViewSkyBlue
        } else {
            textView.backgroundColor = .systemGray6
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "   200자 이내로 작성해주세요."
            textView.textColor = .lightGray
        }
    }
}

extension AddFridgeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3    // TODO: 멤버 검색 결과 수로 변경
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberSearchTableViewCell", for: indexPath) as? MemberSearchTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .none
        return cell
    }
}
