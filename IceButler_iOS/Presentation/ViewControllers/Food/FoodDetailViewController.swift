//
//  FoodDetailViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/10.
//

import UIKit

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
    }
    
    @objc private func deleteFood() {
    }
    
    private func setupObserver() {
        FoodViewModel.shared.food { food in
            self.foodNameLabel.text = food.foodName
            self.foodDetailLabel.text = food.foodDetailName
            self.foodCategoryLabel.text = food.foodCategory
            self.foodShelfLifeLabel.text = food.shelfLife
            self.foodDdayLabel.text = food.day
            self.foodOwnerLabel.text = food.owner
            self.foodMemoLabel.text = food.memo
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
        
        return cell
    }
    
    
}
