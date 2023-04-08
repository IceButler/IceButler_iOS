//
//  FoodAddViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/06.
//

import UIKit

protocol FoodAddDelegate: AnyObject {
    func moveToFoodAddSelect()
}

//육류 과일 채소 음료 수산물 반찬 간식 조미료 가공식품 기타


enum FoodCategory: String, CaseIterable {
    case Meat = "육류"
    case Fruit = "과일"
    case Vegetable = "채소"
    case Drink = "음료"
    case MarineProducts = "수산물"
    case Side = "반찬"
    case Snack = "간식"
    case Seasoning = "조미료"
    case ProcessedFood = "가공식품"
    case ETC = "기타"
}


class FoodAddViewController: UIViewController {
    
    private var delegate: FoodAddDelegate?
    
    @IBOutlet weak var foodNameTextView: UITextView!
    @IBOutlet weak var foodDetailTextView: UITextView!
    
    @IBOutlet weak var categoryOpenButton: UIButton!
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var datePickerOpenButton: UIButton!
    @IBOutlet weak var foodDatePicker: UIDatePicker!
    @IBOutlet weak var foodDatePickerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var foodOwnerTextField: UITextField!
    @IBOutlet weak var foodOwnerTableView: UITableView!
    @IBOutlet weak var foodOwnerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var foodMemoTextView: UITextView!
    
    @IBOutlet weak var foodImageCollectionView: UICollectionView!
    
    @IBOutlet weak var foodAddButton: UIButton!
    
    private var isOpenDatePicker = false
    private var isOpenCategoryView = false
    
    private var selectedFoodCategory: FoodCategory?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupNavgationBar()
    }
    
    private func setup() {
        categoryIconImageView.image = UIImage(named: "categoryOpenIcon")
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        let categoryCell = UINib(nibName: "FoodCategoryCell", bundle: nil)
        categoryTableView.register(categoryCell, forCellReuseIdentifier: "FoodCategoryCell")
    }
    
    private func setupLayout() {
        categoryViewHeight.priority = UILayoutPriority(1000)
        
        
    }
    
    private func setupPlaceholder() {
        
    }
    
    private func setupNavgationBar() {
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        
        let backItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .done, target: self, action: #selector(backToScene))
        backItem.tintColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "식품 추가"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [backItem, titleItem]
    }
    
    @objc private func backToScene() {
        navigationController?.popViewController(animated: true)
        delegate?.moveToFoodAddSelect()
    }
    
    func setDelegate(delegate: FoodAddDelegate) {
        self.delegate = delegate
    }
    
    
    @IBAction func openDatePicker(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.isOpenDatePicker {
                self.foodDatePickerViewHeight.priority = UILayoutPriority(1000)
            }else {
                self.foodDatePickerViewHeight.priority = UILayoutPriority(200)
            }
            self.isOpenDatePicker.toggle()
        }
    }
    
    @IBAction func openCategory(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.isOpenCategoryView {
                self.categoryViewHeight.priority = UILayoutPriority(1000)
                self.categoryIconImageView.image = UIImage(named: "categoryOpenIcon")
            }else {
                self.categoryViewHeight.priority = UILayoutPriority(200)
                self.categoryIconImageView.image = UIImage(named: "categoryCloseIcon")
            }
            self.isOpenCategoryView.toggle()
        }
    }
    
    private func selectFoodCategory(index: Int) {
        selectedFoodCategory = FoodCategory.allCases[index]
        
        categoryOpenButton.titleLabel?.text = selectedFoodCategory?.rawValue
    }
}

extension FoodAddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCategoryCell", for: indexPath) as? FoodCategoryCell else {return UITableViewCell()}
        
        cell.configure(categoryTitle: FoodCategory.allCases[indexPath.row].rawValue)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFoodCategory(index: indexPath.row)
    }
    
    
}
