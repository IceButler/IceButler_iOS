//
//  AlertViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/01.
//

import UIKit

protocol AlertDelegate {
    func deleteFoodsAction()
}

class AlertViewController: UIViewController {
    
    var delegate: AlertDelegate?
    
    private var titleText: String = ""
    private var contentText: String = ""
    private var leftButtonTitle: String = ""
    private var righttButtonTitle: String = ""
    
    private var leftButtonAction: Selector?
    private var rightButtonAction: Selector?
    

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupContents()
    }
    
    // TODO: 이후 Selector 인자를 통해 탭 이벤트 처리할 예정 (임시로 IBAction 사용)
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        self.dismiss(animated: true)
        CartManager.shared.showCartCVTabBar()
    }
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        CartViewModel.shared.deleteFood(cartId: 1)
        self.dismiss(animated: true)
        CartManager.shared.reloadFoodCV()
        CartManager.shared.showCartCVTabBar()
    }
    
    private func setupLayouts() {
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
    
    public func configure(title: String, content: String, leftButtonTitle: String, righttButtonTitle: String) {
        self.titleText = title
        self.contentText = content
        self.leftButtonTitle = leftButtonTitle
        self.righttButtonTitle = righttButtonTitle
    }
    
    private func setupContents() {
        self.titleLabel.text = titleText
        self.contentLabel.text = contentText
        self.leftButton.setTitle(self.leftButtonTitle, for: .normal)
        self.rightButton.setTitle(self.righttButtonTitle, for: .normal)
        
        if let _ = self.leftButtonAction,
           let _ = self.rightButtonAction {
            self.leftButton.addTarget(self, action: self.leftButtonAction!, for: .touchUpInside)
            self.rightButton.addTarget(self, action: self.rightButtonAction!, for: .touchUpInside)
        }
        
    }
    
    public func setLeftButtonAction(action: Selector) { self.leftButtonAction = action }
    public func setRightButtonAction(action: Selector) { self.rightButtonAction = action }
    
}
