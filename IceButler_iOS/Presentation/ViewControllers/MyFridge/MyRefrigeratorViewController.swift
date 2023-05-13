//
//  MyRefrigeratorViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/23.
//

import UIKit

class MyRefrigeratorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var data: MyFridgeResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        /// setting status bar background color
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.signatureLightBlue
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
        
        self.navigationController?.navigationBar.backgroundColor = .signatureLightBlue
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyRefrigeratorTableViewCell", bundle: nil), forCellReuseIdentifier: "MyRefrigeratorTableViewCell")
    }
    
    private func fetchData() {
        
        APIManger.shared.getData(urlEndpointString: "/fridges",
                                 responseDataType: MyFridgeResponseModel.self,
                                 parameter: nil) { [weak self] response in
            if let data = response.data { self?.data = data }
            self?.tableView.reloadData()
        }
    }
}

extension MyRefrigeratorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 188 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fridgeList = data?.fridgeList,
           let multiFridgeResList = data?.multiFridgeResList {
            return fridgeList.count + multiFridgeResList.count
        }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyRefrigeratorTableViewCell", for: indexPath) as? MyRefrigeratorTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.delegate = self
        if indexPath.row < data?.fridgeList?.count ?? 0 {
            cell.configureFridge(data: data?.fridgeList![indexPath.row])
        } else {
            let frigeratorCount = data?.fridgeList?.count ?? 0
            cell.configureMultiFridge(data: data?.multiFridgeResList![indexPath.row - frigeratorCount])
        }
        cell.moreView.isHidden = true
        cell.collectionView.reloadData()
        return cell
    }
}

extension MyRefrigeratorViewController: MyRefrigeratorTableViewCellDelegate {
    func didTapEditButton(index: Int) {
        guard let editViewController = storyboard?.instantiateViewController(withIdentifier: "EditMyFridgeViewController") as? EditMyFridgeViewController else { return }
        
        
        if index < (data?.fridgeList?.count ?? 0) {
            let data = data?.fridgeList![index]
            editViewController.setFridgeIdx(index: data?.fridgeIdx ?? -1)
            editViewController.setFridgeData(isMulti: false,
                                             fridgeName: data?.fridgeName ?? "",
                                             comment: data?.comment ?? "",
                                             members: (data?.users)!,
                                             owner: (data?.users![0])!)
            
        } else {
            let idx = index - (data?.fridgeList?.count ?? 0)
            let data = data?.multiFridgeResList![idx]
            editViewController.setFridgeIdx(index: data?.multiFridgeIdx ?? -1)
            editViewController.setFridgeData(isMulti: true,
                                             fridgeName: data?.multiFridgeName ?? "",
                                             comment: data?.comment ?? "",
                                             members: (data?.users)!,
                                             owner: (data?.users![0])!)
            
        }
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func didTapDeleteButton() {
        guard let alertVC = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        
        alertVC.configure(title: "냉장고 삭제",
                          content: "해당 냉장고를 삭제하시겠습니까?",
                          leftButtonTitle: "취소",
                          righttButtonTitle: "삭제",
                          rightCompletion: {
            
            self.dismiss(animated: false)
            guard let infoVC = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "InfoAlertViewController") as? InfoAlertViewController else { return }
            infoVC.modalPresentationStyle = .fullScreen
            self.present(infoVC, animated: true)
        },
                          leftCompletion: { self.dismiss(animated: true) })
        
        alertVC.modalPresentationStyle = .fullScreen
        present(alertVC, animated: true)
        
    }
}
