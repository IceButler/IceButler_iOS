//
//  FoodAddViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/06.
//

import UIKit
import BSImagePicker
import Photos


protocol FoodAddDelegate: AnyObject {
    func moveToFoodAddSelect()
}

class FoodAddViewController: UIViewController {
    
    private var delegate: FoodAddDelegate?
    
    @IBOutlet weak var foodNameTextView: UITextView!
    @IBOutlet weak var foodDetailTextView: UITextView!
    
    @IBOutlet weak var categoryOpenButton: UIButton!
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var datePickerOpenButton: UIButton!
    @IBOutlet weak var foodDatePicker: UIDatePicker!
    @IBOutlet weak var foodDatePickerViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var foodOwnerTextView: UITextView!
    @IBOutlet weak var foodOwnerTableView: UITableView!
    @IBOutlet weak var foodOwnerView: UIView!
    @IBOutlet weak var foodOwnerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var foodMemoTextView: UITextView!
    
    @IBOutlet weak var foodImageCollectionView: UICollectionView!
    
    @IBOutlet weak var foodAddButton: UIButton!
    
    private let imagePickerController = ImagePickerController()
    
    private var isOpenDatePicker = false
    private var isOpenCategoryView = false
    private var isOpenOwnerTableView = false
    
    private var selectedFoodCategory: FoodCategory?
    
    private var foodImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupNavgationBar()
    }
    
    private func setup() {
        let textViewList = [foodNameTextView, foodDetailTextView, foodOwnerTextView, foodMemoTextView]
        for i in 0..<textViewList.count {
            textViewList[i]?.delegate = self
            textViewList[i]?.tag = i
        }
        
        let tableViewList = [categoryTableView, foodOwnerTableView]
        for j in 0..<tableViewList.count {
            tableViewList[j]?.delegate = self
            tableViewList[j]?.dataSource = self
            tableViewList[j]?.tag = j
            
        }
        
        let categoryCell = UINib(nibName: "FoodCategoryCell", bundle: nil)
        categoryTableView.register(categoryCell, forCellReuseIdentifier: "FoodCategoryCell")
        
        let foodOwnerCell = UINib(nibName: "FoodOwnerCell", bundle: nil)
        foodOwnerTableView.register(foodOwnerCell, forCellReuseIdentifier: "FoodOwnerCell")
        
        
        foodImageCollectionView.delegate = self
        foodImageCollectionView.dataSource = self
        
        let foodAddImageCell = UINib(nibName: "FoodAddImageCell", bundle: nil)
        foodImageCollectionView.register(foodAddImageCell, forCellWithReuseIdentifier: "FoodAddImageCell")
    }
    
    private func setupLayout() {
        categoryViewHeight.priority = UILayoutPriority(1000)
        foodOwnerViewHeight.priority = UILayoutPriority(1000)
        
        [categoryOpenButton, datePickerOpenButton].forEach { button in
            button?.alignTextLeft()
            button?.layer.cornerRadius = 10
        }
        
        [foodNameTextView, foodDetailTextView, foodOwnerTextView, foodMemoTextView].forEach { textView in
            textView?.layer.cornerRadius = 10
            textView?.textAlignment = .left
            textView?.textContainerInset = UIEdgeInsets(top: 13, left: 10, bottom: 0, right: 0)
        }
        
        [categoryTableView, foodOwnerTableView].forEach { tableView in
            tableView?.separatorStyle = .none
            tableView?.layer.cornerRadius = 10
        }
        
        [categoryView, foodOwnerView].forEach { view in
            view?.layer.cornerRadius = 10
        }
        
        foodImageCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        
        
        if let flowLayout = foodImageCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        if foodNameTextView.text == "" {
            foodNameTextView.text = "식품명을 입력해주세요."
            foodNameTextView.textColor = .placeholderColor
        }
        
        if foodDetailTextView.text == "" {
            foodDetailTextView.text = "식품 상세명을 입력해주세요."
            foodDetailTextView.textColor = .placeholderColor
        }
        
        if selectedFoodCategory == nil {
            categoryOpenButton.setTitle("카테고리를 선택해주세요.", for: .normal)
            categoryOpenButton.tintColor = .placeholderColor
            categoryOpenButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        datePickerOpenButton.setTitle("소비기한을 입력해주세요.", for: .normal)
        datePickerOpenButton.tintColor = .placeholderColor
        datePickerOpenButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if foodOwnerTextView.text == "" {
            foodOwnerTextView.text = "닉네임으로 검색해주세요."
            foodOwnerTextView.textColor = .placeholderColor
        }
        
        if foodMemoTextView.text == "" {
            foodMemoTextView.text = "메모내용 or 없음"
            foodMemoTextView.textColor = .placeholderColor
        }
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
                self.datePickerOpenButton.backgroundColor = .focusSkyBlue
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
                self.categoryOpenButton.backgroundColor = .focusSkyBlue
                self.categoryView.backgroundColor = .focusTableViewSkyBlue
                self.categoryViewHeight.priority = UILayoutPriority(200)
                self.categoryIconImageView.image = UIImage(named: "categoryCloseIcon")
            }
            self.isOpenCategoryView.toggle()
        }
    }
    
    private func openOwnerTableView() {
        UIView.animate(withDuration: 0.5) {
            self.foodOwnerView.backgroundColor = .focusTableViewSkyBlue
            self.foodOwnerViewHeight.priority = UILayoutPriority(200)
            self.isOpenOwnerTableView = true
            self.foodOwnerTableView.reloadData()
        }
        
    }
    
    private func selectFoodCategory(index: Int) {
        selectedFoodCategory = FoodCategory.allCases[index]
        
        categoryOpenButton.setTitle(selectedFoodCategory?.rawValue, for: .normal)
    }
    
    private func focusTextView(textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
        textView.backgroundColor = .focusSkyBlue
    }
    
    private func selectImage() {
        imagePickerController.settings.selection.max = 1
        imagePickerController.settings.fetch.assets.supportedMediaTypes = [.image]
        
        self.presentImagePicker(imagePickerController) { (asset) in
            
        } deselect: { (asset) in
            
        } cancel: { (assets) in
            
        } finish: { (assets) in
            let imageManager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            
            assets.forEach { asset in
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: asset,
                                          targetSize: CGSize(width: 79, height: 79),
                                          contentMode: .aspectFit,
                                          options: option) { (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                guard let newImage = UIImage(data: data!) else {return}
                
                self.foodImage = newImage
            }
            
            self.foodImageCollectionView.reloadData()
        }

    }
}

extension FoodAddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0 :
            return FoodCategory.allCases.count
        case 1:
            // user api 받으면 바꿀 예정
            return FoodCategory.allCases.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0 :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCategoryCell", for: indexPath) as? FoodCategoryCell else {return UITableViewCell()}
            
            cell.configure(categoryTitle: FoodCategory.allCases[indexPath.row].rawValue)
            cell.selectionStyle = .none
            
            return cell
        case 1:
            // user api 받으면 바꿀 예정
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodOwnerCell", for: indexPath) as? FoodOwnerCell else {return UITableViewCell()}
            
            cell.configure(name: FoodCategory.allCases[indexPath.row].rawValue)
            cell.selectionStyle = .none
            cell.isFocus(focus: isOpenOwnerTableView)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0 :
            selectFoodCategory(index: indexPath.row)
        case 1:
            // user api 받으면 바꿀 예정
            guard let cell = tableView.cellForRow(at: indexPath)! as? FoodOwnerCell else {return}
            
            cell.selectedOwnerCell()
        default:
            return
        }
    }
}

extension FoodAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView.tag {
        case 0 :
            if textView.text == "식품명을 입력해주세요." {
                focusTextView(textView: textView)
            }
            break
        case 1:
            if textView.text == "식품 상세명을 입력해주세요." {
                focusTextView(textView: textView)
            }
            break
        case 2:
            if textView.text == "닉네임으로 검색해주세요." {
                focusTextView(textView: textView)
            }
            openOwnerTableView()
            break
        case 3:
            if textView.text == "메모내용 or 없음" {
                focusTextView(textView: textView)
            }
            break
        default:
            break
        }
    }
}


extension FoodAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodAddImageCell", for: indexPath) as? FoodAddImageCell else {return UICollectionViewCell()}
        
        if foodImage != nil {
            cell.configure(image: foodImage!)
            cell.hiddenFoodImageAddIcon()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if foodImage == nil {
            selectImage()
        }
    }
    
}

