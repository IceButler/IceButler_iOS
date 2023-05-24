//
//  NotificationViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/23.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
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
        
        let mainText = UILabel()
        mainText.text = "알림"
        mainText.textColor = .white
        mainText.font = .systemFont(ofSize: 18, weight: .bold)
        
        let backItem = UIButton()
        backItem.setImage(UIImage(named: "backIcon"), for: .normal)
        backItem.addTarget(self, action: #selector(didTapBackItem), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: backItem),
            UIBarButtonItem(customView: mainText)
        ]
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    private func setupTableView() {
        let nibName = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "NotificationTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    // MARK: @objc methods
    @objc private func didTapBackItem() { navigationController?.popViewController(animated: true) }
}

// MARK: tableView delgate extension
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // TODO: API 명세서에 따라 수정 예정
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "공지날짜"   // TODO: '오늘', '어제' 등의 title이 오도록 수정
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3    // TODO: API 명세서에 따라 수정 예정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        return cell
    }
}
