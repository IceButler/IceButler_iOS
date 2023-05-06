//
//  EditMyFridgeViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/07.
//

import UIKit

class EditMyFridgeViewController: UIViewController {

    
    @IBOutlet weak var typeContainerView: UIView!
    @IBOutlet weak var fridgeTypeLabel: UILabel!
    
    @IBOutlet weak var fridgeNameContainerView: UIView!
    @IBOutlet weak var fridgeNameTextField: UITextField!
    
    @IBOutlet weak var fridgeCommentContainerView: UIView!
    @IBOutlet weak var fridgeCommentTextView: UITextView!
    
    @IBOutlet weak var memberSearchContainerView: UIView!
    @IBOutlet weak var memberSearchTextField: UITextField!
    @IBOutlet weak var memberSearchResultContainerView: UIView!
    @IBOutlet weak var memberResultTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var intervalOfTableViews: NSLayoutConstraint!
    
    @IBOutlet weak var mandateSearchContainerView: UIView!
    @IBOutlet weak var mandateTextField: UITextField!
    @IBOutlet weak var mandateResultContainerView: UIView!
    @IBOutlet weak var mandateResultTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBAction func didTapMemberSearchButton(_ sender: UIButton) {
        // TODO: 닉네임으로 멤버 검색
    }
    
    @IBAction func didTapMandateSearchButton(_ sender: UIButton) {
        // TODO: 닉네임으로 멤버 검색
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        // TODO: 입력값 체크 및 냉장고 수정 요청
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayouts()
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
        memberResultTableHeight.constant = 43 + 30 * 0
        mandateResultTableHeight.constant = 43 + 30 * 0
        intervalOfTableViews.constant = 40 + 0
    }
    
    // MARK: @objc methods
    @objc private func didTapBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
}
