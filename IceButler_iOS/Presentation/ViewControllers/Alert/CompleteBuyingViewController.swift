//
//  SelectAlertViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/06.
//

import UIKit

class CompleteBuyingViewController: UIViewController {
    
    var completeFoods: [String] = []
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func didTapRightButton(_ sender: UIButton) {
        print("didTapRightButton called")
        let storyboard = UIStoryboard.init(name: "FoodAdd", bundle: nil)
        guard let foodAddViewController = storyboard.instantiateViewController(withIdentifier: "FoodAddViewController") as? FoodAddViewController else { return }
        
        // TODO: 식품 추가 화면에 추가할 식품의 이름,인덱스 정보 배열 넘기기
        self.navigationController?.pushViewController(foodAddViewController, animated: true)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return completeFoods.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 32 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteBuyingTableViewCell", for: indexPath) as? CompleteBuyingTableViewCell else { return UITableViewCell() }
        cell.foodTitleLabel.text = completeFoods[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CompleteBuyingTableViewCell else { return }
        cell.setSelectedFood()
    }
}
