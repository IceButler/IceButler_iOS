//
//  SelectAlertViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/06.
//

import UIKit

class CompleteBuyingViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLayouts()
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        // TODO: 취소 시 장바구니 메인 화면으로 전환
        self.dismiss(animated: true)
    }
    @IBAction func didTapRightButton(_ sender: UIButton) {
        // TODO: 추가 시 식품 추가 메인 화면으로 전환
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupLayouts() {
        self.containerView.layer.cornerRadius = 15
        
        self.leftButton.layer.borderColor = UIColor.lightGray.cgColor
        self.rightButton.tintColor = .lightGray
        self.leftButton.layer.borderWidth = 1.3
        self.leftButton.layer.cornerRadius = 16
        
        self.rightButton.backgroundColor = UIColor.signatureBlue
        self.rightButton.tintColor = .white
        self.rightButton.layer.cornerRadius = 16
    }
    
    private func setupRightButtonAction(action: Selector) {
        self.rightButton.addTarget(self, action: action, for: .touchUpInside)
    }
}

extension CompleteBuyingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10    // TODO: 장바구니에서 선택된 식품(셀)들의 개수로 설정되도록 구현
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 32 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteBuyingTableViewCell", for: indexPath) as? CompleteBuyingTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CompleteBuyingTableViewCell else { return }
        cell.setSelectedFood()
    }
}
