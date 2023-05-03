//
//  SelectFrideViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/26.
//

import UIKit

protocol SelectFridgeDelegate {
    func updateMainFridge(title: String)
}

class SelectFrideViewController: UIViewController {
    
    var delegate: SelectFridgeDelegate?
    private var myFridgeData: [CommonFridgeModel] = []
    private var fridgeCount: Int = 0
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupTableView()
        setupLayout()
    }
    
    private func fetchData() {
        APIManger.shared.getData(urlEndpointString: "/fridges",
                                 responseDataType: MyFridgeResponseModel.self,
                                 requestDataType: MyFridgeResponseModel.self,
                                 parameter: nil) { [weak self] response in
            
            switch response.statusCode {
            case 200:
                self?.configureData(data: response.data)
                self?.tableView.reloadData()
                self?.containerViewHeight.constant = CGFloat(55 * (self?.myFridgeData.count ?? 0) + 120)
            default:
                self?.showAlert(message: "마이냉장고 조회에 실패하였습니다")
            }
        }
    }
    
    private func setupLayout() {
        containerView.backgroundColor = .signatureSkyBlue
        containerView.layer.cornerRadius = 12
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectFridgeTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectFridgeTableViewCell")
    }
    
    private func configureData(data: MyFridgeResponseModel?) {
        if let data = data {
            tableViewHeight.constant = CGFloat(50 * (data.fridgeList!.count + data.multiFridgeResList!.count) + 5)
            fridgeCount = data.fridgeList?.count ?? 0

            data.fridgeList?.forEach({ fridge in
                myFridgeData.append(CommonFridgeModel(idx: fridge.fridgeIdx,
                                                      name: fridge.fridgeName,
                                                      comment: fridge.comment,
                                                      users: fridge.users,
                                                      userCnt: fridge.userCnt))
            })
            data.multiFridgeResList?.forEach({ fridge in
                myFridgeData.append(CommonFridgeModel(idx: fridge.multiFridgeIdx,
                                                      name: fridge.multiFridgeName,
                                                      comment: fridge.comment,
                                                      users: fridge.users,
                                                      userCnt: fridge.userCnt))
            })
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func checkSavedIdx(idx: Int) -> Bool {
        if idx == APIManger.shared.getFridgeIdx() { return true }
        else { return false }
    }
    
    @IBAction func didTapAddFridgeButton(_ sender: UIButton) {
        // TODO: 냉장고 추가 화면으로 이동
        print("TODO: 냉장고 추가 화면으로 이동")
        let addFridgeVC = storyboard?.instantiateViewController(identifier: "AddFridgeViewController") as! AddFridgeViewController
//        present(selectVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(addFridgeVC, animated: true)
    }
    
}

extension SelectFrideViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 50 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return myFridgeData.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFridgeTableViewCell", for: indexPath) as? SelectFridgeTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if indexPath.row < fridgeCount {
            cell.setFridgeModeCell(data: myFridgeData[indexPath.row], isShareFridge: false)
        } else {
            cell.setFridgeModeCell(data: myFridgeData[indexPath.row], isShareFridge: true)
        }
        
        let isSaved = checkSavedIdx(idx: myFridgeData[indexPath.row].idx ?? -1)
        cell.setIsSavedFridge(isSaved: isSaved)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < fridgeCount { APIManger.shared.setIsMultiFridge(data: false) }
        else { APIManger.shared.setIsMultiFridge(data: true) }
        
        let index = myFridgeData[indexPath.row].idx!
        APIManger.shared.setFridgeIdx(index: index)
        delegate?.updateMainFridge(title: myFridgeData[indexPath.row].name ?? "냉장고 이름")
        
        self.dismiss(animated: true)
    }
        
}
