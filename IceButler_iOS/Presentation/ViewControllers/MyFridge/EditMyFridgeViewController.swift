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
    private var fridgeName: String = ""
    private var comment: String = ""
    private var fridgeIdx: Int = -1

    @IBOutlet weak var typeContainerView: UIView!
    @IBOutlet weak var fridgeTypeLabel: UILabel!
    
    @IBOutlet weak var fridgeNameContainerView: UIView!
    @IBOutlet weak var fridgeNameTextField: UITextField!
    
    @IBOutlet weak var fridgeCommentContainerView: UIView!
    @IBOutlet weak var fridgeCommentTextView: UITextView!
    
    @IBOutlet weak var completeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayouts()
        setupSubViews()
        configure()
    }
    
    private func setupNavigationBar() {
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
        fridgeNameTextField.borderStyle = .none
        
        [
            typeContainerView,
            fridgeNameContainerView,
            fridgeCommentContainerView
        ].forEach { btn in btn?.layer.cornerRadius = 12 }
        completeButton.layer.cornerRadius = 25
    }
    
    private func setupSubViews() {
        fridgeCommentTextView.delegate = self
        fridgeNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configure() {
        fridgeTypeLabel.text = "가정용"
        if fridgeName != "" {
            fridgeNameTextField.text = fridgeName
            fridgeNameContainerView.backgroundColor = .focusSkyBlue
        }
        if comment != "" {
            fridgeCommentTextView.text = comment
            fridgeCommentTextView.textColor = .black
            fridgeCommentContainerView.backgroundColor = .focusSkyBlue
        }
    }
    
    private func showAlert(title: String?, message: String, confirmTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default))
        present(alert, animated: true)
    }
    
    public func setFridgeIdx(index: Int) { fridgeIdx = index }
    
    public func configure(fridgeName: String, comment: String) {
        self.fridgeName = fridgeName
        self.comment = comment
    }
    
    @objc private func didTapBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            if let name = fridgeNameTextField.text {
                if name.count > 20 {
                    fridgeNameContainerView.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 219/255, alpha: 0.6)
                    self.view.makeToast("20자 이내의 이름을 입력해주세요!", duration: 1.0, position: .center)
                } else {
                    fridgeNameContainerView.backgroundColor = .focusSkyBlue
                    completeButton.backgroundColor = .availableBlue
                    completeButton.isEnabled = true
                }
            }
        } else {
            fridgeNameContainerView.backgroundColor = .notInputColor
            completeButton.backgroundColor = .systemGray4
            completeButton.isEnabled = false
        }
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        if let name = fridgeNameTextField.text, !name.isEmpty {
            if name.count > 20 {
                showAlert(title: "냉장고 수정 실패", message: "20자가 넘는 이름을 가질 수 없습니다.", confirmTitle: "확인")
                return
            }
        }
        
        if fridgeCommentTextView.text.count > 200 {
            showAlert(title: "냉장고 수정 실패", message: "200자가 넘는 코멘트를 가질 수 없습니다.", confirmTitle: "확인")
            return
        }
        
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            var comment = self.fridgeCommentTextView.text
            if comment == "200자 이내로 작성해주세요." { comment = "" }
            
            APIManger.shared.patchData(urlEndpointString: "/fridges/\(self.fridgeIdx)",
                                     responseDataType: MyFridgeResponseModel.self,
                                     parameter: ["fridgeName": self.fridgeNameTextField.text!,
                                               "comment": comment!]) { [weak self] response in
                switch response.statusCode {
                case 200: self?.navigationController?.popViewController(animated: true)
                default: self?.showAlert(title: "마이냉장고 수정 실패", message: response.description ?? "", confirmTitle: "확인")
                }
            }
            
            hud.dismiss(animated: true)
        }
    }
}

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
            fridgeCommentContainerView.backgroundColor = .focusSkyBlue
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "200자 이내로 작성해주세요."
            textView.textColor = .lightGray
        }
    }
}
