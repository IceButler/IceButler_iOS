//
//  FoodAddViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/06.
//

import UIKit
import BSImagePicker
import Photos
import Alamofire


protocol FoodAddDelegate: AnyObject {
    func moveToFoodAddSelect()
}


// MARK: -
class FoodAddViewController: UIViewController {    
    
    @IBOutlet weak var foodNameTextView: UITextView!
    @IBOutlet weak var foodDetailTextView: UITextView!
    
    @IBOutlet weak var foodNameGptCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryOpenButton: UIButton!
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var categoryGptCollectionView: UICollectionView!
    
    @IBOutlet weak var datePickerOpenButton: UIButton!
    @IBOutlet weak var foodDatePicker: UIDatePicker!
    @IBOutlet weak var foodDatePickerViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var ownerOpenButton: UIButton!
    @IBOutlet weak var foodOwnerTableView: UITableView!
    @IBOutlet weak var foodOwnerView: UIView!
    @IBOutlet weak var foodOwnerIconImageView: UIImageView!
    @IBOutlet weak var foodOwnerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var foodMemoTextView: UITextView!
    
    @IBOutlet weak var foodImageCollectionView: UICollectionView!
    
    @IBOutlet weak var foodAddButton: UIButton!
    
    private let imagePickerController = ImagePickerController()
    
    private var delegate: FoodAddDelegate?
    
    private var isOpenDatePicker = false
    private var isOpenCategoryView = false
    private var isOpenOwnerTableView = false
    
    private var selectedFoodCategory: FoodCategory?
    
    private var foodOwnerIdx: Int?
    private var foodImage: UIImage?
    private var foodImageUrl: String?
    private var date: Date?
    
    private var selectedOwner: [Bool] = []
    private var ownerName: String = ""
    
    private var addedFoodNames: [String] = []
    private var buyedFoods: [BuyedFood] = []
    private var currentFoodIndex: Int = -1  /// '이전', '다음' 버튼을 위한 인덱스
    private var savedFoods: [FoodAddRequestModel] = []
    
    private var foodIdx: Int = 0
    
    private var isEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupNavgationBar()
        setupBeforeAfterNavItems()
        setupObserver()
        setupAddedFoodName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setup() {
        FoodViewModel.shared.getFoodOwnerList(fridgeIdx: APIManger.shared.getFridgeIdx())
        
        let textViewList = [foodNameTextView, foodDetailTextView, foodMemoTextView]
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
        
        
        
        let collectionViewList = [foodNameGptCollectionView, categoryGptCollectionView, foodImageCollectionView]
        for k in 0..<collectionViewList.count {
            collectionViewList[k]?.delegate = self
            collectionViewList[k]?.dataSource = self
            collectionViewList[k]?.tag = k
            
        }
        
        let gptCell = UINib(nibName: "ChatGptCell", bundle: nil)
        foodNameGptCollectionView.register(gptCell, forCellWithReuseIdentifier: "ChatGptCell")
        categoryGptCollectionView.register(gptCell, forCellWithReuseIdentifier: "ChatGptCell")
        
        let foodAddImageCell = UINib(nibName: "FoodAddImageCell", bundle: nil)
        foodImageCollectionView.register(foodAddImageCell, forCellWithReuseIdentifier: "FoodAddImageCell")
        
        foodDatePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
    }
    
    private func setupLayout() {
        if buyedFoods.count > 1 { self.foodAddButton.isHidden = true }
        else { self.foodAddButton.isHidden = false }
        
        self.navigationController?.isNavigationBarHidden = false
        
        categoryViewHeight.priority = UILayoutPriority(1000)
        foodOwnerViewHeight.priority = UILayoutPriority(1000)
        
        [categoryOpenButton, datePickerOpenButton, ownerOpenButton].forEach { button in
            button?.alignTextLeft()
            button?.layer.cornerRadius = 10
        }
        
        [foodNameTextView, foodDetailTextView,  foodMemoTextView].forEach { textView in
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
        [foodNameGptCollectionView, categoryGptCollectionView, foodImageCollectionView].forEach { collectionView in
            collectionView?.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        }
        
        foodAddButton.layer.cornerRadius = 30
        
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
        
        
        if foodMemoTextView.text == "" {
            foodMemoTextView.text = "메모내용 or 없음"
            foodMemoTextView.textColor = .placeholderColor
        }
    }
    
    
    private func setupNavgationBar() {
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
        titleLabel.text = "식품 추가"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [backItem, titleItem]
    }
    
    private func setupObserver() {
        FoodViewModel.shared.foodOwnerList {
            for _ in 0..<FoodViewModel.shared.foodOwnerListCount() {
                self.selectedOwner.append(false)
            }
            self.foodOwnerTableView.reloadData()
            
            
            
            if FoodViewModel.shared.isEditFood == true && FoodViewModel.shared.foodOwnerListCount() != 0 {
                let editFood = FoodViewModel.shared.getFood()
                
                for i in 0..<FoodViewModel.shared.foodOwnerListCount() {
                    if FoodViewModel.shared.foodOwnerListName(index: i) == editFood.owner {
                        self.foodOwnerIdx = FoodViewModel.shared.foodOwnerListIdx(index: i)
                    }
                }
                
                self.ownerOpenButton.tintColor = .black
                self.ownerOpenButton.backgroundColor = .focusSkyBlue
                self.ownerOpenButton.setTitle(editFood.owner ?? "", for: .normal)
                
               
            }
        }
        
        FoodViewModel.shared.barcodeFood { barcodeFood in
            if barcodeFood == nil {
                self.foodDetailTextView.text = ""
                self.setupLayout()
                self.setupPlaceholder()
            }else {
                self.foodDetailTextView.text = barcodeFood?.foodDetailName
                self.foodDetailTextView.textColor = .black
                self.foodDetailTextView.backgroundColor = .focusSkyBlue
                FoodViewModel.shared.setIsFoodAddComplete(index: 0)
            }
        }
        
        FoodViewModel.shared.selectedSearchFood { searchFood in
            self.setFoodCategory(gptFoodCategory: searchFood.foodCategory)
            self.foodNameTextView.text = searchFood.foodName
            self.foodNameTextView.textColor = .black
            self.foodNameTextView.backgroundColor = .focusSkyBlue
        }
        
        
        FoodViewModel.shared.isEditFood { isEditFood in
            self.isEdit = isEditFood
            if isEditFood {
                FoodViewModel.shared.getFood { food in
                    self.foodIdx = food.fridgeFoodIdx
                    
                    
                    self.foodNameTextView.text = food.foodName
                    self.foodDetailTextView.text = food.foodDetailName
                    
                    for i in 0..<FoodCategory.allCases.count {
                        if FoodCategory.allCases[i].rawValue == food.foodCategory {
                            self.selectFoodCategory(index: i)
                        }
                    }
                    
                    
                    let dateFromat = DateFormatter()
                    dateFromat.dateFormat = "yyyy-MM-dd"
                    
                    let date = dateFromat.date(from: food.shelfLife!)
                    
                    UIView.animate(withDuration: 0.5) {
                        self.datePickerOpenButton.backgroundColor = .focusSkyBlue
                        self.datePickerOpenButton.tintColor = .black
                        self.datePickerOpenButton.setTitle(food.shelfLife, for: .normal)
                    }
                    
                    self.date = date
                    self.foodDatePicker.date = date!
                    
                    
                    self.foodMemoTextView.text = food.memo
                    
                    self.foodImageUrl = food.imgURL
                    
                    
                    for i in 0..<FoodViewModel.shared.foodOwnerListCount() {
                        if FoodViewModel.shared.foodOwnerListName(index: i) == food.owner {
                            self.foodOwnerIdx = FoodViewModel.shared.foodOwnerListIdx(index: i)
                        }
                    }
                    
                    self.foodAddButton.backgroundColor = .availableBlue
                }
            }
        }
        
        FoodViewModel.shared.isFoodAddCmplete { isFoodAddCmplete in
            if isFoodAddCmplete == true && self.isEdit == false {
                self.foodAddButton.backgroundColor = .availableBlue
            }
        }
        
        
        
        DispatchQueue.main.async {
            FoodViewModel.shared.isChangeFoodCategories {
                UIView.transition(with: self.categoryGptCollectionView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                    self.categoryGptCollectionView.reloadData()},
                                  completion: nil)
            }
            
            FoodViewModel.shared.isChangeGptFoodNames {
                UIView.transition(with: self.foodNameGptCollectionView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                    self.foodNameGptCollectionView.reloadData()},
                                  completion: nil)
            }
        }
    }
    
    /// 장보기 완료 후 식품 추가를 통해 화면 전환되었을 때 기본값으로 0번째 데이터를 화면에 구성
    private func setupAddedFoodName() {
        if self.buyedFoods.count > 0 {
            self.foodNameTextView.text = self.buyedFoods[0].name
            currentFoodIndex = 0
            
            self.buyedFoods.forEach { food in
                savedFoods.append(FoodAddRequestModel(foodName: food.name,
                                                      foodDetailName: "",
                                                      foodCategory: "",
                                                      shelfLife: "",
                                                      memo: nil,
                                                      imgKey: nil,
                                                      ownerIdx: -1))
            }
        }
    }
    
    @objc private func backToScene() {
        if isEdit {
            navigationController?.popViewController(animated: true)
        }else {
            FoodViewModel.shared.deleteAll()
            navigationController?.popViewController(animated: true)
            delegate?.moveToFoodAddSelect()
        }
    }
    
    func setDelegate(delegate: FoodAddDelegate) {
        self.delegate = delegate
    }
    
    func setAddedFoodNames(names: [String]) {
        self.addedFoodNames = names
    }
    
    func setBuyedFoods(foods: [BuyedFood]) {
        self.buyedFoods = foods
    }
    
    /// 장보기 완료 후 여러 개의 식품 추가가 필요한 경우 '이전','다음' 버튼을 추가
    func setupBeforeAfterNavItems() {
        let beforeButton: UIButton = {
            let button = UIButton()
            button.setTitle("이전", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
            button.backgroundColor = .white
            button.setTitleColor(.navigationColor, for: .normal)
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(didTapBeforeButton), for: .touchUpInside)
            return button
        }()
        
        let afterButton: UIButton = {
            let button = UIButton()
            button.setTitle("다음", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
            button.backgroundColor = .white
            button.setTitleColor(.navigationColor, for: .normal)
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(didTapAfterButton), for: .touchUpInside)
            return button
        }()
        
        if self.buyedFoods.count > 0 {
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(customView: afterButton),
                UIBarButtonItem(customView: beforeButton)
            ]
        }
        
    }
    
    private func setupFoodData() {
        if currentFoodIndex == buyedFoods.count-1 { self.foodAddButton.isHidden = false }
        
        let foodData = savedFoods[currentFoodIndex]
        
        self.foodDetailTextView.text = foodData.foodDetailName
        self.foodNameTextView.text = foodData.foodName
        self.foodOwnerIdx = foodData.ownerIdx
        
        /// reset UI
        setupPlaceholder()
        if foodData.foodDetailName == "" {
            foodDetailTextView.backgroundColor = .notInputColor
        } else { foodDetailTextView.textColor = .black }
        
        if foodData.foodCategory == "" {
            categoryOpenButton.setTitle("카테고리를 선택해주세요.", for: .normal)
            categoryOpenButton.tintColor = .placeholderColor
            categoryOpenButton.backgroundColor = .notInputColor
        } else {
            categoryOpenButton.setTitle(foodData.foodCategory, for: .normal)
            categoryOpenButton.backgroundColor = .focusSkyBlue
            categoryOpenButton.tintColor = .black
        }
        
        if foodData.shelfLife == "" {
            datePickerOpenButton.backgroundColor = .notInputColor
            datePickerOpenButton.setTitle("소비기한을 입력해주세요.", for: .normal)
        } else {
            datePickerOpenButton.backgroundColor = .focusSkyBlue
            datePickerOpenButton.setTitle(foodData.shelfLife, for: .normal)
            datePickerOpenButton.tintColor = .black
        }
        
        if foodData.ownerIdx == -1 {
            ownerOpenButton.setTitle("", for: .normal)
            ownerOpenButton.backgroundColor = .notInputColor
        }
        else {
            ownerOpenButton.setTitle(ownerName, for: .normal)
            ownerOpenButton.backgroundColor = .focusSkyBlue
        }
        
        if foodData.memo == nil {
            foodMemoTextView.text = "메모내용 or 없음"
            foodMemoTextView.backgroundColor = .notInputColor
            foodMemoTextView.textColor = .placeholderColor
        } else {
            foodMemoTextView.text = foodData.memo
            foodMemoTextView.backgroundColor = .focusSkyBlue
            foodMemoTextView.textColor = .black
        }
        
        if foodData.imgKey == nil {
            foodImage = nil
            self.foodImageCollectionView.reloadData()
        }
        
    }
    
    /// '이전' 버튼 탭 이벤트 정의
    @objc func didTapBeforeButton() {
        preSaveFoodInfo()
        
        if currentFoodIndex > 0 {
            currentFoodIndex -= 1
            setupFoodData()
        }
        else {  showAlert(title: "", message: "가장 앞 순서의 데이터입니다!") }
    }
    
    /// '다음' 버튼 탭 이벤트 정의
    @objc func didTapAfterButton() {
        preSaveFoodInfo()
        
        if currentFoodIndex < buyedFoods.count-1 {
            currentFoodIndex += 1
            setupFoodData()
        }
        else {
            showAlert(title: "", message: "가장 뒷 순서의 데이터입니다!")
        }
        
    }
    
    @objc func selectDate() {
        let dateFromat = DateFormatter()
        dateFromat.dateFormat = "yyyy-MM-dd"
        
        UIView.animate(withDuration: 0.5) {
            self.datePickerOpenButton.backgroundColor = .focusSkyBlue
            self.datePickerOpenButton.tintColor = .black
            self.datePickerOpenButton.setTitle(dateFromat.string(from: self.foodDatePicker.date), for: .normal)
        }
        
        
        date = foodDatePicker.date
        FoodViewModel.shared.setIsFoodAddComplete(index: 3)
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
                self.categoryView.backgroundColor = .focusTableViewSkyBlue
                self.categoryViewHeight.priority = UILayoutPriority(200)
                self.categoryIconImageView.image = UIImage(named: "categoryCloseIcon")
            }
            self.isOpenCategoryView.toggle()
        }
    }
    
    
    @IBAction func openOwnerTableView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.isOpenOwnerTableView {
                self.foodOwnerViewHeight.priority = UILayoutPriority(1000)
                self.foodOwnerIconImageView.image = UIImage(named: "categoryOpenIcon")
            }else {
                self.foodOwnerView.backgroundColor = .focusTableViewSkyBlue
                self.foodOwnerViewHeight.priority = UILayoutPriority(200)
                self.foodOwnerIconImageView.image = UIImage(named: "categoryCloseIcon")
                self.foodOwnerTableView.reloadData()
            }
            self.isOpenOwnerTableView.toggle()
        }
    }
    
    private func selectFoodCategory(index: Int) {
        selectedFoodCategory = FoodCategory.allCases[index]
        UIView.animate(withDuration: 0.5) {
            self.categoryOpenButton.backgroundColor = .focusSkyBlue
            self.categoryOpenButton.tintColor = .black
            self.categoryOpenButton.setTitle(self.selectedFoodCategory?.rawValue, for: .normal)
        }
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
    
    private func preSaveFoodInfo() {
        if savedFoods.count > 0 {
            if date != nil {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                savedFoods[currentFoodIndex].shelfLife = dateFormat.string(from: date!)
            }
            if foodNameTextView.text != "" && foodNameTextView.text != "식품명을 입력해주세요." {
                savedFoods[currentFoodIndex].foodName = foodNameTextView.text
            }
            if foodDetailTextView.text != "" && foodDetailTextView.text != "식품 상세명을 입력해주세요." {
                savedFoods[currentFoodIndex].foodDetailName = foodDetailTextView.text
            }
            if selectedFoodCategory != nil && categoryOpenButton.title(for: .normal) != "카테고리를 선택해주세요." {
                savedFoods[currentFoodIndex].foodCategory = selectedFoodCategory!.rawValue
            }
            if datePickerOpenButton.title(for: .normal) != "소비기한을 입력해주세요." {
                savedFoods[currentFoodIndex].shelfLife = datePickerOpenButton.title(for: .normal)!
            }
            if foodOwnerIdx != -1 {
                savedFoods[currentFoodIndex].ownerIdx = foodOwnerIdx ?? -1
            }
            if foodMemoTextView.text != "" && foodMemoTextView.text != "메모내용 or 없음" {
                savedFoods[currentFoodIndex].memo = foodMemoTextView.text
            }
            if foodImage != nil {
                
                FoodViewModel.shared.getUploadImageUrl(imageDir: ImageDir.Food, image: foodImage!) { [weak self] imgUrl in
                    self?.savedFoods[(self?.currentFoodIndex)!].imgKey = imgUrl
                    
                }
            }
            else { savedFoods[currentFoodIndex].imgKey = nil }
            
            print("임시저장된 식품 정보 --> index: \(currentFoodIndex) \n\(savedFoods[currentFoodIndex])")
            
        }
    }
    
    @IBAction func foodAdd(_ sender: Any) {
        preSaveFoodInfo()
        
        if savedFoods.count > 0 {
            if checkForSaveFoodInfo() {
                let fridgeIdx = APIManger.shared.getFridgeIdx()
                let param = FoodAddListModel(fridgeFoods: savedFoods)
                
                print("요청할 식품 정보들 --> \(param)")
                
                var url = ""
                if APIManger.shared.getIsMultiFridge() { url = "/multiFridges/\(fridgeIdx)/food" }
                else { url = "/fridges/\(fridgeIdx)/food" }
                
                APIManger.shared.postData(urlEndpointString: url,
                                          responseDataType: FoodAddRequestModel.self,
                                          requestDataType: FoodAddListModel.self,
                                          parameter: param,
                                          completionHandler: { [weak self] response in
                    
                    print("장보기 완료 후 식품추가 요청 결과 ----> \(response)")
                    if response.statusCode == 200 {
                        self?.showAlert(title: "", message: "음식 등록에 성공하였습니다!")
                        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
                        let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController")
                        self?.navigationController?.pushViewController(cartVC, animated: true)
                    } else {
                        self?.showAlert(title: "", message: "음식 등록에 실패하였습니다")
                    }
                    return
                })
            }
            
        } else {
            if date == nil {
                showAlert(title: "유통기한 오류", message: "유통 기한을 입력해주세요.")
                return
            }else if date! < Date() {
                showAlert(title: "유통기한 오류", message: "유통기한이 지난 제품은 등록 할 수 없습니다.")
                return
            }
            if foodNameTextView.text == "" || foodNameTextView.text == "식품명을 입력해주세요." {
                showAlert(title: "오류", message: "식품명을 입력해주세요.")
                return
            }
            if foodDetailTextView.text == "" || foodDetailTextView.text == "식품 상세명을 입력해주세요." {
                showAlert(title: "오류", message: "식품 상세명을 입력해주세요.")
                return
            }
            if selectedFoodCategory == nil {
                showAlert(title: "오류", message: "카테고리를 선택해주세요.")
                return
            }

            let memo: String?
            
            if foodMemoTextView.text == "" || foodMemoTextView.text == "메모내용 or 없음" {
                memo = nil
            }else {
                memo = foodMemoTextView.text
            }
            
            let dateFromat = DateFormatter()
            dateFromat.dateFormat = "yyyy-MM-dd"
            let dateString = dateFromat.string(from: date!)
            
            if isEdit {
                if foodImage != nil {
                    let fridgeIdx = APIManger.shared.getFridgeIdx()
                    
                    FoodViewModel.shared.getUploadImageUrl(foodIdx: foodIdx,
                                                           imageDir: ImageDir.Food,
                                                           image: foodImage!,
                                                           fridgeIdx: fridgeIdx,
                                                           foodName: foodNameTextView.text,
                                                           foodDetail: foodDetailTextView.text,
                                                           foodCategory: selectedFoodCategory!.rawValue,
                                                           foodShelfLife: dateString,
                                                           foodOwnerIdx: foodOwnerIdx,
                                                           memo: memo) { result in
                        if result {
                            let alert = UIAlertController(title: "성공", message: "음식 수정에 성공하셨습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                                FoodViewModel.shared.getFoodDetail( foodIdx: self.foodIdx)
                                FoodViewModel.shared.isEditFood = false
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true)
                        }else {
                            self.showAlert(title: "실패", message: "음식 수정에 실패하셨습니다. 다시 시도해주세요.")
                        }
                        
                    }
                } else {
                    let fridgeIdx = APIManger.shared.getFridgeIdx()
                    FoodViewModel.shared.patchFood(foodIdx: self.foodIdx, fridgeIdx: fridgeIdx,
                                                   foodName: foodNameTextView.text,
                                                   foodDetail: foodDetailTextView.text,
                                                   foodCategory: selectedFoodCategory!.rawValue,
                                                   foodShelfLife: dateString,
                                                   foodOwnerIdx: foodOwnerIdx,
                                                   memo: memo,
                                                   imgUrl: self.foodImageUrl) { result in
                        if result {
                            let alert = UIAlertController(title: "성공", message: "음식 수정에 성공하셨습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                                FoodViewModel.shared.isEditFood = false
                                FoodViewModel.shared.getFoodDetail( foodIdx: self.foodIdx)
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true)
                        }else {
                            self.showAlert(title: "실패", message: "음식 수정에 실패하셨습니다. 다시 시도해주세요.")
                        }
                    }
                }
            }else {
                if foodImage != nil {
                    let fridgeIdx = APIManger.shared.getFridgeIdx()
                    FoodViewModel.shared.getUploadImageUrl(imageDir: ImageDir.Food,
                                                           image: foodImage!,
                                                           fridgeIdx: fridgeIdx,
                                                           foodName: foodNameTextView.text,
                                                           foodDetail: foodDetailTextView.text,
                                                           foodCategory: selectedFoodCategory!.rawValue,
                                                           foodShelfLife: dateString,
                                                           foodOwnerIdx: foodOwnerIdx,
                                                           memo: memo) { result in
                        if result {
                            let alert = UIAlertController(title: "성공", message: "음식 등록에 성공하셨습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                                FoodViewModel.shared.deleteAll()
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true)
                        }else {
                            self.showAlert(title: "실패", message: "음식 등록에 실패하셨습니다. 다시 시도해주세요.")
                        }

                    }
                } else {
                    let fridgeIdx = APIManger.shared.getFridgeIdx()
                    FoodViewModel.shared.postFood(fridgeIdx: fridgeIdx,
                                                  foodName: foodNameTextView.text,
                                                  foodDetail: foodDetailTextView.text,
                                                  foodCategory: selectedFoodCategory!.rawValue,
                                                  foodShelfLife: dateString,
                                                  foodOwnerIdx: foodOwnerIdx,
                                                  memo: memo,
                                                  imgUrl: nil) { result in
                        if result {
                            let alert = UIAlertController(title: "성공", message: "음식 등록에 성공하셨습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                                FoodViewModel.shared.deleteAll()
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true)
                        }else {
                            self.showAlert(title: "실패", message: "음식 등록에 실패하셨습니다. 다시 시도해주세요.")
                        }
                    }
                }
            }
        }
    }
        
        func checkForSaveFoodInfo() -> Bool {
            var result = true
            savedFoods.forEach { food in
                if food.shelfLife == "" {
                    showAlert(title: "유통기한 오류", message: "유통 기한을 입력해주세요.")
                    result = false
                    
                } else if date! < Date() {
                    showAlert(title: "유통기한 오류", message: "유통기한이 지난 제품은 등록 할 수 없습니다.")
                    result = false
                }
                
                if food.foodName == "" || food.foodName == "식품명을 입력해주세요." {
                    showAlert(title: "오류", message: "식품명을 입력해주세요.")
                    result = false
                }
                
                if food.foodDetailName == "" || food.foodDetailName == "식품 상세명을 입력해주세요." {
                    showAlert(title: "오류", message: "식품 상세명을 입력해주세요.")
                    result = false
                }
                
                if food.foodCategory == "" {
                    showAlert(title: "오류", message: "카테고리를 선택해주세요.")
                    result = false
                }
                
                if foodOwnerIdx == -1 {
                    showAlert(title: "오류", message: "음식 소유자를 선택해주세요.")
                    result = false
                }
            }
            return result
        }
        
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
        
        func setFoodNameTextView(gptFoodName: String) {
            UIView.animate(withDuration: 0.5) {
                self.foodNameTextView.textColor = .black
                self.foodNameTextView.backgroundColor = .focusSkyBlue
                self.foodNameTextView.text = gptFoodName
            }
        }
        
        func setFoodCategory(gptFoodCategory: String) {
            for i in 0..<FoodCategory.allCases.count {
                if FoodCategory.allCases[i].rawValue == gptFoodCategory {
                    selectFoodCategory(index: i)
                }
            }
        }
        
        func selectOwner(index: Int) {
            for i in 0..<selectedOwner.count {
                if i == index {
                    selectedOwner[i] = true
                }else {
                    selectedOwner[i] = false
                }
            }
            
            UIView.animate(withDuration: 0.5) {
                self.ownerOpenButton.tintColor = .black
                self.ownerOpenButton.backgroundColor = .focusSkyBlue
                self.ownerOpenButton.setTitle(FoodViewModel.shared.foodOwnerListName(index: index), for: .normal)
            }
            
            UIView.transition(with: self.foodOwnerTableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { () -> Void in
                self.foodOwnerTableView.reloadData()},
                              completion: nil)
        }
        
        func setIsEdit(isEdit: Bool) {
            self.isEdit = isEdit
        }
}

    
    extension FoodAddViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch tableView.tag {
            case 0 :
                return FoodCategory.allCases.count
            case 1:
                return FoodViewModel.shared.foodOwnerListCount()
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
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodOwnerCell", for: indexPath) as? FoodOwnerCell else {return UITableViewCell()}
                
                FoodViewModel.shared.foodOwnerListName(index: indexPath.row, store: &cell.cancellabels) { ownerName in
                    //                cell.configure(name: ownerName, isSelect: self.selectedOwner[indexPath.row])
                    self.ownerName = ownerName
                    cell.configure(name: ownerName, isSelect: false)
                }
                
                FoodViewModel.shared.foodOwnerListImage(index: indexPath.row, store: &cell.cancellabels) { url in
                    cell.setImage(imageUrl: url)
                }
                
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
                FoodViewModel.shared.setIsFoodAddComplete(index: 2)
            case 1:
                selectOwner(index: indexPath.row)
                self.foodOwnerIdx = FoodViewModel.shared.foodOwnerListIdx(index: indexPath.row)
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
                if textView.text == "메모내용 or 없음" {
                    focusTextView(textView: textView)
                }
                break
            default:
                break
            }
        }
        
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text != "" {
                if textView.tag == 0 {
                    FoodViewModel.shared.setIsFoodAddComplete(index: 1)
                }else if textView.tag == 1 {
                    FoodViewModel.shared.setIsFoodAddComplete(index: 0)
                }
            }
            
            if textView.tag == 1 {
                FoodViewModel.shared.getGptFood(foodDetailName: textView.text)
            }
        }
        
    }
    





// MARK: -
    
    extension FoodAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch collectionView.tag {
            case 0:
                return FoodViewModel.shared.gptFoodNamesCount()
            case 1:
                return FoodViewModel.shared.gptFoodCategoriesCount()
            case 2:
                return 1
            default:
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch collectionView.tag {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatGptCell", for: indexPath) as? ChatGptCell else {return UICollectionViewCell()}
                
                FoodViewModel.shared.gptFoodNames(index: indexPath.row, store: &cell.cancelLabels) { foodName in
                    cell.configure(gptText: foodName)
                }
                
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatGptCell", for: indexPath) as? ChatGptCell else {return UICollectionViewCell()}
                
                FoodViewModel.shared.gptFoodCategory(index: indexPath.row, store: &cell.cancelLabels) { foodCategory in
                    cell.configure(gptText: foodCategory)
                }
                
                return cell
            case 2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodAddImageCell", for: indexPath) as? FoodAddImageCell else {return UICollectionViewCell()}
                
                if foodImage != nil {
                    cell.setImage(image: foodImage!)
                    cell.hiddenFoodImageAddIcon()
                    
                } else {
                    cell.showFoodImageAddIcon()
                }
                
                return cell
            default:
                return UICollectionViewCell()
            }
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView.tag == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatGptCell", for: indexPath) as? ChatGptCell else {return}
                FoodViewModel.shared.gptFoodNames(index: indexPath.row, store: &cell.cancelLabels) { foodName in
                    self.setFoodNameTextView(gptFoodName: foodName)
                    FoodViewModel.shared.setIsFoodAddComplete(index: 1)
                }
            }else if collectionView.tag == 1 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatGptCell", for: indexPath) as? ChatGptCell else {return}
                FoodViewModel.shared.gptFoodCategory(index: indexPath.row, store: &cell.cancelLabels) { foodCategory in
                    self.setFoodCategory(gptFoodCategory: foodCategory)
                    FoodViewModel.shared.setIsFoodAddComplete(index: 2)
                }
            }else if collectionView.tag == 2 {
                if foodImage == nil {
                    selectImage()
                }
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView.tag == 0 {
                let sizeLabel = UILabel()
                sizeLabel.font = .systemFont(ofSize: 14)
                sizeLabel.text = FoodViewModel.shared.getGptFoodName(index: indexPath.row)
                sizeLabel.sizeToFit()
                return CGSize(width: sizeLabel.frame.width + 30, height: 34)
            }else if collectionView.tag == 1{
                let sizeLabel = UILabel()
                sizeLabel.font = .systemFont(ofSize: 14)
                sizeLabel.text = FoodViewModel.shared.getGptFoodCategory(index: indexPath.row)
                sizeLabel.sizeToFit()
                return CGSize(width: sizeLabel.frame.width + 30, height: 34)
            }else {
                return CGSize(width: 79, height: 79)
            }
        }
    }
    
    

