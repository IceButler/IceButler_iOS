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
    @IBOutlet weak var fridgeNameTextField: UITextField!
    @IBOutlet weak var fridgeDetailTextView: UITextView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: @IBAction
    @IBAction func didTapFridgeButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapMultiFridgeButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapMemberSearchButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        
    }
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayouts()
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
            fridgeButton,
            multiFridgeButton,
            searchContainerView,
            completeButton
            
        ].forEach { btn in
            btn?.layer.cornerRadius = 12
        }
    }
    
    
    // MARK: @objc methods
    @objc private func didTapBackItem() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
