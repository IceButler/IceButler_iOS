//
//  AlertViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit


class AlertViewController: UIViewController {
    
    private var titleText: String = ""
    private var contentText: String = ""
    private var leftButtonTitle: String = ""
    private var righttButtonTitle: String = ""
    
    private var leftButtonAction: Selector?
    private var rightButtonAction: Selector?
    
    private var rightCompletion: (() -> Void)?
    private var leftCompletion: (() -> Void)?
    

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupContents()
        setButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CartViewModel.shared.removeFoodNames.removeAll()
    }
    
    // TODO: 이후 Selector 인자를 통해 탭 이벤트 처리할 예정 (임시로 IBAction 사용)
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupLayouts() {
        self.navigationController?.isNavigationBarHidden = true
        self.containerView.layer.cornerRadius = 15
        self.titleLabel.textColor = .signatureBlue
        
        self.leftButton.layer.borderColor = UIColor.lightGray.cgColor
        self.rightButton.tintColor = .lightGray
        self.leftButton.layer.borderWidth = 1.3
        self.leftButton.layer.cornerRadius = 16
        
        self.rightButton.backgroundColor = UIColor.signatureBlue
        self.rightButton.tintColor = .white
        self.rightButton.layer.cornerRadius = 16
    }
    
    public func configure(title: String, content: String, leftButtonTitle: String, righttButtonTitle: String, rightCompletion: @escaping () -> Void, leftCompletion: @escaping () -> Void) {
        self.titleText = title
        self.contentText = content
        self.leftButtonTitle = leftButtonTitle
        self.righttButtonTitle = righttButtonTitle
        self.rightCompletion = rightCompletion
        self.leftCompletion = leftCompletion
    }
    
    private func setupContents() {
        self.titleLabel.text = titleText
        self.contentLabel.text = contentText
        self.leftButton.setTitle(self.leftButtonTitle, for: .normal)
        self.rightButton.setTitle(self.righttButtonTitle, for: .normal)
    }
    
    func setButtonAction() {
        leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
    }
    
    // MARK: @objc methods
    @objc func leftAction() {
        self.dismiss(animated: true)
        leftCompletion!()
    }
    @objc func rightAction() {
        self.dismiss(animated: true)
        rightCompletion!()
    }

}
