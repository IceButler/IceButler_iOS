//
//  FoodDetailViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import UIKit
import Toast_Swift
import JGProgressHUD

class FoodDetailViewController: UIViewController {

    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDetailLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var foodShelfLifeLabel: UILabel!
    @IBOutlet weak var foodDdayLabel: UILabel!
    @IBOutlet weak var foodOwnerLabel: UILabel!
    @IBOutlet weak var foodMemoLabel: UILabel!
    @IBOutlet weak var foodImageCollectionView: UICollectionView!
    @IBOutlet weak var completeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupObserver()
        setupNavigationBar()
    }
    
    private func setup() {
        foodImageCollectionView.dataSource = self
        foodImageCollectionView.delegate = self
        
        let foodImageCell = UINib(nibName: "FoodAddImageCell", bundle: nil)
        foodImageCollectionView.register(foodImageCell, forCellWithReuseIdentifier: "FoodAddImageCell")
    }
    
    private func setupLayout() {
        [foodNameLabel, foodDetailLabel, foodCategoryLabel, foodShelfLifeLabel, foodDdayLabel, foodOwnerLabel, foodMemoLabel].forEach { label in
            label?.clipsToBounds = true
            label?.backgroundColor = .focusTableViewSkyBlue
            label?.layer.cornerRadius = 10
        }
        
        foodMemoLabel.lineBreakMode = .byCharWrapping
        foodMemoLabel.numberOfLines = 4
        
        foodImageCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        
        if let flowLayout = foodImageCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func setupNavigationBar() {
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
            statusBar?.backgroundColor = UIColor.navigationColor
        }
        
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        
        let backItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .done, target: self, action: #selector(backToScene))
        backItem.tintColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "식품 상세정보"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [backItem, titleItem]
        

        let editItem = UIBarButtonItem(image: UIImage(named: "editIcon"), style: .done, target: self, action: #selector(moveToEdit))
        editItem.tintColor = .white
        let deleteItem = UIBarButtonItem(image: UIImage(named: "deleteIcon"), style: .done, target: self, action: #selector(deleteFood))
        deleteItem.tintColor = .white
        
        self.navigationItem.rightBarButtonItems = [deleteItem, editItem]
    }
    
    
    @objc private func backToScene() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moveToEdit() {
        let foodEditVC = UIStoryboard(name: "FoodAdd", bundle: nil).instantiateViewController(withIdentifier: "FoodAddViewController") as! FoodAddViewController
        
        FoodViewModel.shared.isEditFood = true
        
        self.navigationController?.pushViewController(foodEditVC, animated: true)
    }
    
    @objc private func deleteFood() {
        let alertVC = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        
        let foodIdx = FoodViewModel.shared.getFood().fridgeFoodIdx
        
        alertVC.configure(title: "식품 삭제", content: "해당 식품을 삭제하시겠습니까?", leftButtonTitle: "폐기", righttButtonTitle: "섭취") {
            DispatchQueue.main.async { [self] in
                let hud = JGProgressHUD()
                hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                hud.style = .light
                hud.show(in: self.view)
                
                FoodViewModel.shared.eatFoods(foodIdx: foodIdx) { result in
                    
                    hud.dismiss(animated: true)
                    if result {
                        self.view.makeToast("해당 식품이 정상적으로 섭취 처리되었습니다.", duration: 1.0, position: .center)
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        self.view.makeToast("식품 섭취 처리에 오류가 발생하였습니다. 다시 시도해주세요.", duration: 1.0, position: .center)
                    }
                }
            }
            
        } leftCompletion: {
            DispatchQueue.main.async { [self] in
                let hud = JGProgressHUD()
                hud.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                hud.style = .light
                hud.show(in: self.view)
                
                FoodViewModel.shared.deleteFoods(foodIdx: foodIdx) { result in
                    hud.dismiss(animated: true)
                    if result {
                        self.view.makeToast("해당 식품이 정상적으로 삭제되었습니다.", duration: 1.0, position: .center)
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        self.view.makeToast("식품 삭제에 오류가 발생하였습니다. 다시 시도해주세요.", duration: 1.0, position: .center)
                    }
                }
                
            }
            
           
        }
        
        alertVC.modalPresentationStyle = .overFullScreen
        
        self.present(alertVC, animated: true)

    }
    
    private func setupObserver() {
        FoodViewModel.shared.food { food in
            self.foodNameLabel.text = food.foodName
            self.foodDetailLabel.text = food.foodDetailName
            self.foodCategoryLabel.text = food.foodCategory
            self.foodShelfLifeLabel.text = food.shelfLife
            self.foodOwnerLabel.text = food.owner
            self.foodMemoLabel.text = food.memo
            
            if food.day > 0 {
                self.foodDdayLabel.text = "D+" + food.day.description
            }else {
                self.foodDdayLabel.text = "D" + food.day.description
            }
            
            if food.day > -4 {
                self.foodDdayLabel.backgroundColor = UIColor(red: 255/225, green: 219/225, blue: 219/225, alpha: 0.6)
                self.foodDdayLabel.textColor = UIColor(red: 187/225, green: 62/225, blue: 62/225, alpha: 1)
            }else {
                self.foodDdayLabel.backgroundColor = .focusTableViewSkyBlue
                self.foodDdayLabel.textColor = .black
            }
            
        }
    }
    
    
    
}

extension FoodDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodAddImageCell", for: indexPath) as! FoodAddImageCell
        
        cell.hiddenFoodImageAddIcon()
        
        FoodViewModel.shared.foodImage { imgUrl in
            cell.configure(imageUrl: imgUrl)
        }
        
        return cell
    }
    
    
}
