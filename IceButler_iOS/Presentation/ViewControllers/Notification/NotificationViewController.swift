//
//  NotificationViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/23.
//

import UIKit
import JGProgressHUD
import Toast_Swift

class NotificationViewController: UIViewController {
    
    private var createdAtList: [String] = []
    private var renameCreatedAtList: [String : String] = [:]
    private var dateList: [String] = []
    private var notifications: [String : [Notification]] = [:]

    @IBOutlet var nothingLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func configure() {
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            hud.style = .light
            hud.show(in: self.view)
            
            self.fetchData()
            self.tableView.reloadData()
            
            hud.dismiss(animated: true)
        }
    }
    
    private func fetchData() {
        APIManger.shared.getData(urlEndpointString: "/users/notification",
                                 responseDataType: NotificationResponseModel.self,
                                 parameter: nil,
                                 completionHandler: { [weak self] response in
            switch response.statusCode {
            case 200:
                if let data = response.data {
                    if data.content.count > 0 {
                        self?.setupData(data: data.content)
                        self?.tableView.reloadData()
                    }
                    else {
                        self?.nothingLabel.isHidden = false
                        self?.tableView.isHidden = true
                    }
                }
                else {
                    self?.nothingLabel.isHidden = false
                    self?.tableView.isHidden = true
                }
                
            default:
                self?.view.makeToast("알림 목록을 불러오는데 실패하였습니다.", duration: 1.0, position: .center)
            }
            
        })
    }
    
    private func setupData(data: [Notification]) {
        data.forEach { d in
            if let createdAt = d.createdAt {
                if !(createdAtList.contains(createdAt)) {
                    self.createdAtList.append(createdAt)
                }
            }
        }

        var temp: [Notification] = []
        createdAtList.forEach { createdAt in
            data.forEach { d in
                if d.createdAt == createdAt {
                    temp.append(d)
                }
            }
            notifications[createdAt] = temp
            temp.removeAll()
        }
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
        backItem.frame = CGRect(x: 0, y: 0, width: 35, height: 20)
        
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

    func numberOfSections(in tableView: UITableView) -> Int { return createdAtList.count }

     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if createdAtList.count > 0 { return createdAtList[section] }
        else { return "알림날짜" }
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return notifications[createdAtList[section]]!.count }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
         cell.configure(data: notifications[createdAtList[indexPath.section]]![indexPath.row])
         return cell
     }
 }
