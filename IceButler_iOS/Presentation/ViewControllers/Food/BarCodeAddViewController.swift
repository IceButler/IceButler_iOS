//
//  BarCodeViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/05.
//

import UIKit

class BarCodeAddViewController: UIViewController {
    
    @IBOutlet weak var barCodeView: BarCodeView!
    @IBOutlet weak var centerGuideLineView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupNavigationBar()
    }
    
    private func setup() {
        barCodeView.delegate = self
        barCodeView.start()
    }
    
    private func setupLayout() {
                
        barCodeView.layer.cornerRadius = 10
        
        barCodeView.layer.borderColor = CGColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1)
        barCodeView.layer.borderWidth = 3
        
        cancelButton.backgroundColor = .white
        
        cancelButton.layer.cornerRadius = cancelButton.frame.width / 2
        
        cancelButton.layer.borderColor = CGColor(red: 170 / 255, green: 204 / 255, blue: 249 / 255, alpha: 1)
        cancelButton.layer.borderWidth = 1
        
        
        centerGuideLineView.backgroundColor = .signatureDeepBlue
    }
    
    private func setupNavigationBar() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        
        let okButton = UIAlertAction(title: "확인", style: .default) { action in
            self.barCodeView.start()
        }
        
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    @IBAction func backToScene(_ sender: Any) {
        barCodeView.stop()
        self.dismiss(animated: true)
    }
}

extension BarCodeAddViewController: BarCodeViewDelgate {
    func readerComplete(status: ReaderStatus) {
        switch status {
        case .success(let code):
            guard let code = code else {
                showAlert(title: "에러", message: "바코드를 인식하지 못했습니다.")
                break
            }
            showAlert(title: "성공", message: code)
        case .fail:
            showAlert(title: "에러", message: "바코드를 인식하지 못했습니다.")
            break
        }
    }
    
    
}
