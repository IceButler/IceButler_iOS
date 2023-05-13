//
//  InfoAlertViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/13.
//

import UIKit

class InfoAlertViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        // TODO: 조건을 만족하는 경우 삭제 처리?
        print("didTapConfirmButton called")
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 12
        confirmButton.layer.cornerRadius = 22
    }
}
