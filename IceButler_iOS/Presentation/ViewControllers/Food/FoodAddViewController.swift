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
    private var date: Date?
    private var addedFoodNames: [String] = []
    private var selectedOwner: [Bool] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupNavgationBar()
        setupObserver()
        setupAddedFoodName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setup() {
        FoodViewModel.shared.getFoodOwnerList(fridgeIdx: 1)
        
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
    
    private func setupAddedFoodName() {
        if self.addedFoodNames.count > 1 {
            self.foodNameTextView.text = self.addedFoodNames[0] // 임시
        }
    }
    
    @objc private func backToScene() {
        FoodViewModel.shared.deleteAll()
        navigationController?.popViewController(animated: true)
        delegate?.moveToFoodAddSelect()
    }
    
    func setDelegate(delegate: FoodAddDelegate) {
        self.delegate = delegate
    }
    
    func setAddedFoodNames(names: [String]) {
        self.addedFoodNames = names
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
    
    @IBAction func foodAdd(_ sender: Any) {
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
        
        if foodOwnerIdx == nil {
            showAlert(title: "오류", message: "음식 소유자를 선택해주세요.")
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
        
        if foodImage != nil {
            FoodViewModel.shared.getUploadImageUrl(imageDir: ImageDir.Food, image: foodImage!, fridgeIdx: 1, foodName: foodNameTextView.text, foodDetail: foodDetailTextView.text, foodCategory: selectedFoodCategory!.rawValue, foodShelfLife: dateString, foodOwnerIdx: foodOwnerIdx!, memo: memo) { result in
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
        }else {
            FoodViewModel.shared.postFood(fridgeIdx: 1, foodName: foodNameTextView.text, foodDetail: foodDetailTextView.text, foodCategory: selectedFoodCategory!.rawValue, foodShelfLife: dateString, foodOwnerIdx: foodOwnerIdx!, memo: memo, imgUrl: nil) { result in
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    private func setFoodNameTextView(gptFoodName: String) {
        UIView.animate(withDuration: 0.5) {
            self.foodNameTextView.textColor = .black
            self.foodNameTextView.backgroundColor = .focusSkyBlue
            self.foodNameTextView.text = gptFoodName
        }
    }
    
    private func setFoodCategory(gptFoodCategory: String) {
        for i in 0..<FoodCategory.allCases.count {
            if FoodCategory.allCases[i].rawValue == gptFoodCategory {
                selectFoodCategory(index: i)
            }
        }
    }
    
    private func selectOwner(index: Int) {
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
                cell.configure(name: ownerName, isSelect: self.selectedOwner[indexPath.row])
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
        if textView.tag == 1 {
            FoodViewModel.shared.getGptFood(foodDetailName: textView.text)
        }
    }
    
}


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
            }
        }else if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatGptCell", for: indexPath) as? ChatGptCell else {return}
            FoodViewModel.shared.gptFoodCategory(index: indexPath.row, store: &cell.cancelLabels) { foodCategory in
                self.setFoodCategory(gptFoodCategory: foodCategory)
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

