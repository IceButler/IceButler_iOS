//
//  MyRefrigeratorViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/23.
//

import UIKit
import JGProgressHUD

class MyRefrigeratorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var data: MyFridgeResponseModel?
    private var tableCellHeight = 198
    private var highlightedCellIdx = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupNavigationBar()
        setupTableView()
//        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        fetchData()
        tableView.reloadData()
    }
    
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
        
        
        /// set up title
        let titleLabel = UILabel()
        titleLabel.text = "마이 냉장고"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        /// set up right item
        let backItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .done, target: self, action: #selector(didTapBackItem))
        let titleItem = UIBarButtonItem(customView: titleLabel)
        backItem.tintColor = .white
        self.navigationItem.leftBarButtonItems = [ backItem, titleItem ]
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyFridgeTableViewCell", bundle: nil), forCellReuseIdentifier: "MyFridgeTableViewCell")
    }
    
    private func fetchData() {
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            APIManger.shared.getData(urlEndpointString: "/fridges",
                                     responseDataType: MyFridgeResponseModel.self,
                                     parameter: nil) { [weak self] response in
                if let data = response.data { self?.data = data }
                self?.reloadTableViewAnimation()
            }
            
            hud.dismiss(animated: true)
        }
    }
    
    
    
    private func reloadTableViewAnimation() {
        UIView.transition(with: self.tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.tableView.reloadData()},
                          completion: nil);
    }
    
    // MARK: @objc methods
    @objc private func didTapBackItem() { self.navigationController?.popViewController(animated: true) }
    
}

extension MyRefrigeratorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 198
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = self.data,
              let fridgeList = data.fridgeList else {
            return 0
        }
        return fridgeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyFridgeTableViewCell", for: indexPath) as? MyFridgeTableViewCell else {
            return UITableViewCell()
        }
        
        guard let data = self.data,
              let fridgeList = data.fridgeList else {
            return UITableViewCell()
        }
        
        cell.configure(data: fridgeList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditMyFridgeViewController") as? EditMyFridgeViewController else { return }
        
        guard let data = self.data,
              let fridgeList = data.fridgeList else {
            return
        }
        
        let idx = indexPath.row
        editViewController.setFridgeIdx(index: fridgeList[idx].fridgeIdx ?? -1)
        editViewController.configure(fridgeName: fridgeList[idx].fridgeName ?? "",
                                   comment: fridgeList[idx].comment ?? "")
        editViewController.delegate = self
        
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let data = self.data,
                  let fridgeList = data.fridgeList else {
                return
            }
            
            let idx = indexPath.row
            removeFridgeIdx = fridgeList[idx].fridgeIdx ?? -1
            
            let alert = UIAlertController(title: "냉장고 삭제", message: "정말로 이 냉장고를 삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                self?.removeFridge()
            })
            present(alert, animated: true)
        }
    }
}

extension MyRefrigeratorViewController: FridgeRemoveDelegate {
    func reloadMyFridgeVC() { self.reloadTableViewAnimation() }
    
    func showMessageFailToRemoveFridge(message: String) {
        let alert = UIAlertController(title: "냉장고 삭제 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
