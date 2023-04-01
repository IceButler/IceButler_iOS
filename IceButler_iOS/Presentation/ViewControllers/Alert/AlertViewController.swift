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
    }
    
//    public func setLeftButtonAction(action: ()->()) {
//        self.leftButton.addTarget(self, action: #selector(action), for: .touchUpInside)
//    }
}
