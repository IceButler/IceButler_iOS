//
//  AddFridgeViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/02.
//

import UIKit
import JGProgressHUD

protocol AddFridgeDelegate {
    func setNewFidgeNameTitle(name: String)
}

class AddFridgeViewController: UIViewController {

    // MARK: @IBOutlet, Variables
    var delegate: AddFridgeDelegate?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameFieldContainer: UIView!
    @IBOutlet weak var fridgeNameTextField: UITextField!
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var fridgeDetailTextView: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: @IBAction
    @IBAction func didTapBackItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        if let name = fridgeNameTextField.text {
            if name.count > 20 {
                showAlert(title: "냉장고 추가 실패", message: "20자가 넘는 이름을 가질 수 없습니다.", confirmTitle: "확인")
                return
            }
        }
        
        if fridgeDetailTextView.text.count > 200 {
            showAlert(title: "냉장고 추가 실패", message: "200자가 넘는 코멘트를 가질 수 없습니다.", confirmTitle: "확인")
            return
        }
        
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            var comment = self.fridgeDetailTextView.text
            if comment == "200자 이내로 작성해주세요." { comment = "" }
            
            FridgeViewModel.shared.requestAddFridge(isMulti: false,
                                                  name: self.fridgeNameTextField.text!,
                                                  comment: comment!,
                                                  members: [],
                                                  completion: { [weak self] result in
                if result {
                    self?.dismiss(animated: true)
                    FridgeViewModel.shared.currentFridgeName = (self?.fridgeNameTextField.text)!
                    self?.delegate?.setNewFidgeNameTitle(name: FridgeViewModel.shared.currentFridgeName)
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
        fridgeDetailTextView.delegate = self
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
        fridgeNameTextField.borderStyle = .none
        
        [nameFieldContainer, detailContainerView].forEach { view in
            view?.layer.cornerRadius = 12
        }
        completeButton.layer.cornerRadius = 24
    }
    
    private func setupTextInputTargets() {
        fridgeNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fridgeDetailTextView.delegate = self
    }
    
    private func showAlert(title: String?, message: String, confirmTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default))
        present(alert, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            if let name = fridgeNameTextField.text {
                if name.count > 20 {
                    nameFieldContainer.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 219/255, alpha: 0.6)
                    self.view.makeToast("20자 이내의 이름을 입력해주세요!", duration: 1.0, position: .center)
                } else {
                    nameFieldContainer.backgroundColor = .focusTableViewSkyBlue
                    completeButton.backgroundColor = .availableBlue
                    completeButton.isEnabled = true
                }
            }
        } else {
            nameFieldContainer.backgroundColor = .notInputColor
            completeButton.backgroundColor = .systemGray4
            completeButton.isEnabled = false
        }
    }
}

extension AddFridgeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
        detailContainerView.backgroundColor = .notInputColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            detailContainerView.backgroundColor = .notInputColor
        } else if textView.text.count > 200 {
            detailContainerView.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 219/255, alpha: 0.6)
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
