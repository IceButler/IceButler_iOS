//
//  FoodAddSelectViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/05.
//

import UIKit
import SnapKit

protocol FoodAddSelectDelgate: AnyObject {
    func showFoodAddButton()
    func moveToFoodAddViewController(foodAddVC: FoodAddViewController)
    func moveToSearchFoodVC(searchFoodVC: SearchFoodViewController)
}

class FoodAddSelectViewController: UIViewController {
    @IBOutlet weak var foodAddSelectTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: FoodAddSelectDelgate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }
    
    private func setup() {
        foodAddSelectTableView.delegate = self
        foodAddSelectTableView.dataSource = self
        
        let foodAddSelectCell = UINib(nibName: "FoodAddSelectCell", bundle: nil)
        foodAddSelectTableView.register(foodAddSelectCell, forCellReuseIdentifier: "FoodAddSelectCell")
    }
    
    private func setupLayout() {
        foodAddSelectTableView.layer.cornerRadius = 20
        
        
        cancelButton.snp.makeConstraints { make in
            if UIDevice.hasNotch {
                make.bottom.equalTo(self.view.snp.bottom).offset(126)
            } else {
                make.bottom.equalTo(self.view.snp.bottom).offset(86)
            }
        }
        
        cancelButton.backgroundColor = .white
        
        cancelButton.layer.cornerRadius = cancelButton.frame.width / 2
        cancelButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        cancelButton.layer.shadowColor = CGColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.1)
        cancelButton.layer.shadowOpacity = 1
    }
    
    func setupDelegate(delegate: FoodAddSelectDelgate) {
        self.delegate = delegate
    }
    
    
    @IBAction func backToScene(_ sender: Any) {
        self.dismiss(animated: true)
        delegate?.showFoodAddButton()
    }
    
}

extension FoodAddSelectViewController: BarCodeAddProtocol {
    func moveToFoodAdd() {
        self.dismiss(animated: false) {
            let foodAddVC = UIStoryboard(name: "FoodAdd", bundle: nil).instantiateViewController(identifier: "FoodAddViewController") as! FoodAddViewController
            
            self.delegate?.moveToFoodAddViewController(foodAddVC: foodAddVC)
        }
    }
}

extension FoodAddSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return tableView.layer.frame.height / 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodAddSelectCell") as! FoodAddSelectCell
        
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0 :
            cell.configure(image: UIImage(named: "barcodeAddIcon")!, title: "바코드 스캔")
        case 1:
            cell.configure(image: UIImage(named: "searchAddIcon")!, title: "식품 검색")
        case 2:
            cell.configure(image: UIImage(named: "writeAddIcon")!, title: "직접 추가")
        default:
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let barCodeAddVC = UIStoryboard(name: "BarCodeAdd", bundle: nil).instantiateViewController(identifier: "BarCodeAddViewController") as! BarCodeAddViewController
            
            barCodeAddVC.modalTransitionStyle = .coverVertical
            barCodeAddVC.modalPresentationStyle = .fullScreen
            
            barCodeAddVC.setDelegate(delegate: self)
            
            present(barCodeAddVC, animated: true)
            break
        case 1:
            let searchFoodVC = UIStoryboard(name: "SearchFood", bundle: nil).instantiateViewController(identifier: "SearchFoodViewController") as! SearchFoodViewController
            
            self.dismiss(animated: true) {
                self.delegate?.moveToSearchFoodVC(searchFoodVC: searchFoodVC)
            }
            break
        case 2:
            let foodAddVC = UIStoryboard(name: "FoodAdd", bundle: nil).instantiateViewController(identifier: "FoodAddViewController") as! FoodAddViewController
            
            self.dismiss(animated: true) {
                FoodViewModel.shared.barcodeFoodInfo = nil
                self.delegate?.showFoodAddButton()
                self.delegate?.moveToFoodAddViewController(foodAddVC: foodAddVC)
            }
            break
        default:
            break
        }
    }
}



