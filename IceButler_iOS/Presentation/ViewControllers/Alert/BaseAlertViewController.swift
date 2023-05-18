//
//  BaseAlertViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/15.
//

import UIKit

class BaseAlertViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var leadingConstraintToContainerView: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintToContainerView: NSLayoutConstraint!
    
    private var titleText: String = ""
    private var contentText: String = ""
    private var leadingConstant: Double? = nil
    private var trailingConstant: Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setButtonAction()
    }
    
    private func setupLayout() {
        if leadingConstant != nil && trailingConstant != nil {
            leadingConstraintToContainerView.constant = leadingConstant!
            trailingConstraintToContainerView.constant = trailingConstant!
        }
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        titleLabel.text = titleText
        titleLabel.textColor = .signatureDeepBlue
        contentLabel.text = contentText
        okButton.backgroundColor = .signatureBlue
        okButton.setTitleColor(.white, for: .normal)
        okButton.layer.cornerRadius = okButton.frame.height / 2
        okButton.layer.masksToBounds = true
    }
    
    private func setButtonAction() {
        okButton.addTarget(self, action: #selector(tappedOkButton), for: .touchUpInside)
    }
    
    @objc func tappedOkButton() {
        self.dismiss(animated: true)
    }
    
    func configure(title: String, content: String, leadingConstant: Double? = nil, trailingConstant: Double? = nil) {
        titleText = title
        contentText = content
        self.leadingConstant = leadingConstant
        self.trailingConstant = trailingConstant
    }
}
