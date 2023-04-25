//
//  SelectFrideViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/26.
//

import UIKit

class SelectFrideViewController: UIViewController {
    
    private var myFridgeData: [String] = ["우리 집 냉장고", "쉐어하우스 냉장고"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectFridgeTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectFridgeTableViewCell")
    }
}

extension SelectFrideViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFridgeData.count + 1 
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFridgeTableViewCell", for: indexPath) as? SelectFridgeTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if indexPath.row == myFridgeData.count { cell.setAddFridgeModeCell() }
        else { cell.setMyFridgeModeCell(data: myFridgeData[indexPath.row], isShareFridge: false) }
        
        return cell
    }
    
}
