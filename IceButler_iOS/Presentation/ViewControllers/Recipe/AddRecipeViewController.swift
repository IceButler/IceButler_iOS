//
//  AddRecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/04.
//

import UIKit
import Photos

class AddRecipeViewController: UIViewController, ReceiveSecondDataDelegate {
    private let MENU_NAME_MAX_LENGTH = 20
    private let GENERAL_MAX_LENGTH = 3
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var representativeImageLabel: UILabel!
    @IBOutlet weak var addRepresentativeImageButton: UIButton!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuNameView: UIView!
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryOpenButton: UIButton!
    @IBOutlet weak var categoryOpenImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var timeRequiredLabel: UILabel!
    @IBOutlet weak var timeRequiredView: UIView!
    @IBOutlet weak var timeRequiredTextField: UITextField!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var ingredientNameView: UIView!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var ingredientAmountView: UIView!
    @IBOutlet weak var ingredientAmountTextField: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var ingredientStackViewTopConstraintToIngredientTableView: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    private var isOpenCategoryView: Bool = false
    private var addedIngredientList: [[String]] = []
    
    weak var firstDateDelegate: ReceiveFirstDataDelegate?
    private var addedCookingProcessList: [[Any?]] = []
    
    // 레시피 수정
    private var recipeIdx: Int? = nil
    private var isEditMode: Bool = false
    private var recipeDetail: RecipeDetailResponseModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setupLayout()
    }
    
    private func setup() {
        menuNameTextField.delegate = self
        amountTextField.delegate = self
        timeRequiredTextField.delegate = self
        ingredientNameTextField.delegate = self
        ingredientAmountTextField.delegate = self
        
        let tableViewList = [categoryTableView, ingredientTableView]
        for i in 0..<tableViewList.count {
            tableViewList[i]?.delegate = self
            tableViewList[i]?.dataSource = self
            tableViewList[i]?.tag = i
        }
        ingredientTableView.rowHeight = UITableView.automaticDimension
        
        let categoryCell = UINib(nibName: "RecipeCategoryTableViewCell", bundle: nil)
        categoryTableView.register(categoryCell, forCellReuseIdentifier: "RecipeCategoryCell")
        let ingredientCell = UINib(nibName: "RecipeIngredientTableViewCell", bundle: nil)
        ingredientTableView.register(ingredientCell, forCellReuseIdentifier: "RecipeIngredientCell")
        
        // 글자수 제한
        NotificationCenter.default.addObserver(self, selector: #selector(menuNameTextDidChange), name: UITextField.textDidChangeNotification, object: menuNameTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(amountTextDidChange), name: UITextField.textDidChangeNotification, object: amountTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(timeRequiredTextDidChange), name: UITextField.textDidChangeNotification, object: timeRequiredTextField)
        // 입력 감지 후 배경색 변경
        menuNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        amountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        timeRequiredTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .navigationColor
        
        let title = UILabel()
        if isEditMode {
            title.text = "레시피 수정"
        } else {
            title.text = "레시피 추가"
        }
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = .white
        title.textAlignment = .left
        title.sizeToFit()
        
        self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: title))
        
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
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupLayout() {
        setupPlaceholder()
        setupCornerRadius()
        setupColor()
        addRepresentativeImageButton.setImage(UIImage(named: "imageAddIcon"), for: .normal)
        categoryTableView.separatorStyle = .none
        ingredientTableView.separatorStyle = .none
        if isEditMode {
            setupLayoutForEdit()
        }
    }
    
    private func setupPlaceholder() {
        // 메뉴명
        let menuNamePlaceholder = "영어, 한글, 숫자 (20자 이내)"
        menuNameTextField.attributedPlaceholder = NSAttributedString(string: menuNamePlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderColor])
        // 레시피 카테고리
        let categoryPlaceholder = "카테고리를 선택해주세요."
        categoryOpenButton.alignTextLeft()
        let attributedTitle = NSAttributedString(string: categoryPlaceholder, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.placeholderColor])
        categoryOpenButton.setAttributedTitle(attributedTitle, for: .normal)
        categoryOpenButton.backgroundColor = .notEnteredStateColor
        // 분량
        servingLabel.textColor = .placeholderColor
        // 소요시간
        minuteLabel.textColor = .placeholderColor
        // 재료
        let ingredientNamePlaceholder = "재료명"
        ingredientNameTextField.attributedPlaceholder = NSAttributedString(string: ingredientNamePlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderColor])
        let ingredientAmountPlaceholder = "양 (ex.1큰술)"
        ingredientAmountTextField.attributedPlaceholder = NSAttributedString(string: ingredientAmountPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderColor])
    }
    
    private func setupCornerRadius() {
        addRepresentativeImageButton.layer.cornerRadius = 10
        addRepresentativeImageButton.layer.masksToBounds = true
        menuNameView.layer.cornerRadius = 10
        menuNameView.layer.masksToBounds = true
        categoryOpenButton.layer.cornerRadius = 10
        categoryOpenButton.layer.masksToBounds = true
        categoryTableView.layer.cornerRadius = 10
        categoryTableView.layer.masksToBounds = true
        amountView.layer.cornerRadius = 10
        amountView.layer.masksToBounds = true
        timeRequiredView.layer.cornerRadius = 10
        timeRequiredView.layer.masksToBounds = true
        ingredientNameView.layer.cornerRadius = 10
        ingredientNameView.layer.masksToBounds = true
        ingredientAmountView.layer.cornerRadius = 10
        ingredientAmountView.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.layer.masksToBounds = true
    }
    
    private func setupColor() {
        representativeImageLabel.textColor = .textDeepBlue
        menuNameLabel.textColor = .textDeepBlue
        categoryLabel.textColor = .textDeepBlue
        categoryTableView.backgroundColor = .notEnteredStateColor.withAlphaComponent(0.4)
        amountLabel.textColor = .textDeepBlue
        timeRequiredLabel.textColor = .textDeepBlue
        ingredientLabel.textColor = .textDeepBlue
        nextButton.backgroundColor = .disabledButtonGray
    }
    
    private func setupLayoutForEdit() {
        // 사진은 이미 업로드된 이미지... 만약 디테일에 있는 거랑 같은 거면 업로드할 것 없고
        // 사진 바꿨으면 업로드해서 서버 주고... 근데 킹피셔가 String->UIImage로 타입 바꿔주긴 함. 그대로 전부 보내도 ㄱㅊ긴함
        if let url = URL(string: recipeDetail!.recipeImgUrl) {
            addRepresentativeImageButton.kf.setImage(with: url, for: .normal)
            addRepresentativeImageButton.contentMode = .scaleAspectFill
        }
        // 메뉴명
        menuNameView.backgroundColor = .focusSkyBlue
        menuNameTextField.text = recipeDetail!.recipeName
        let attributedTitle = NSAttributedString(string: recipeDetail!.recipeCategory, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        // 카테고리
        categoryOpenButton.backgroundColor = .focusSkyBlue
        categoryTableView.backgroundColor = .focusTableViewSkyBlue
        categoryOpenButton.setAttributedTitle(attributedTitle, for: .normal)
        // 분량 및 소요시간
        amountView.backgroundColor = .focusSkyBlue
        amountTextField.text = "\(recipeDetail!.quantity)"
        timeRequiredView.backgroundColor = .focusSkyBlue
        timeRequiredTextField.text = "\(recipeDetail!.leadTime)"
        // 재료
        for ingredient in recipeDetail!.recipeFoods {
            addedIngredientList.append([ingredient.foodName, ingredient.foodDetail])
        }
        ingredientStackViewTopConstraintToIngredientTableView.priority = UILayoutPriority(1000)
        ingredientTableView.reloadData()
        scrollView.invalidateIntrinsicContentSize()
        // 조리과정
        for cookery in recipeDetail!.cookery {
            addedCookingProcessList.append([cookery.cookeryImgUrl, cookery.description])
        }
        // 기본적으로 textfield 배경색 파랗게 하기
        changeNextButtonColor()
    }
    
    func configure(recipeIdx: Int, isEditMode: Bool, recipeDetail: RecipeDetailResponseModel) {
        self.recipeIdx = recipeIdx
        self.isEditMode = isEditMode
        self.recipeDetail = recipeDetail
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapAddRepresentativeImageButton(_ sender: Any) {
        authorizePhotoAccess()
    }
    
    @IBAction func didTapCategoryOpenButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            if self.isOpenCategoryView {
                self.categoryViewHeight.priority = UILayoutPriority(1000)
                self.categoryOpenImageView.image = UIImage(named: "recipeCategoryOpenIcon")
            } else {
                self.categoryViewHeight.priority = UILayoutPriority(250)
                self.categoryOpenImageView.image = UIImage(named: "recipeCategoryCloseIcon")
            }
        }
        isOpenCategoryView.toggle()
    }
    
    @IBAction func didTapAddIngredientButton(_ sender: Any) {
        if !ingredientNameTextField.text!.isEmpty && !ingredientAmountTextField.text!.isEmpty {
            addedIngredientList.append([ingredientNameTextField.text!, ingredientAmountTextField.text!])
            ingredientNameTextField.text = nil
            ingredientAmountTextField.text = nil
            view.endEditing(true)
            ingredientStackViewTopConstraintToIngredientTableView.priority = UILayoutPriority(1000)
            ingredientTableView.reloadData()
            scrollView.invalidateIntrinsicContentSize()
            changeNextButtonColor()
        }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        if nextButton.backgroundColor == .availableBlue {
            guard let addRecipeSecondViewController = storyboard!.instantiateViewController(withIdentifier: "AddRecipeSecondViewController") as? AddRecipeSecondViewController else { return }
            if isEditMode {
                addRecipeSecondViewController.configure(recipeIdx: recipeIdx!, isEditMode: isEditMode)
            }
            self.firstDateDelegate = addRecipeSecondViewController
            addRecipeSecondViewController.secondDateDelegate = self
            firstDateDelegate?.receiveDataFromFirstAddVC(addedCookingProcessList: addedCookingProcessList, representativeImage: addRepresentativeImageButton.imageView!.image!, menuName: menuNameTextField.text!, category: categoryOpenButton.titleLabel!.text!, amount: Int(amountTextField.text!) ?? 0, timeRequired: Int(timeRequiredTextField.text!) ?? 0, addedIngredientList: addedIngredientList)
            self.navigationController?.pushViewController(addRecipeSecondViewController, animated: true)
        } else {
            if addRepresentativeImageButton.imageView!.image!.isEqual(UIImage(named: "imageAddIcon")) ||
               menuNameTextField.text?.isEmpty ?? true ||
               categoryOpenButton.backgroundColor != .focusSkyBlue ||
               amountTextField.text?.isEmpty ?? true ||
               timeRequiredTextField.text?.isEmpty ?? true {
                showBaseAlert(title: "필수 항목 입력", content: "모든 항목을 입력해야 합니다.")
            }
            else if ingredientTableView.numberOfRows(inSection: 0) < 2 {
                showBaseAlert(title: "재료 개수 제한", content: "재료는 최소 2개 이상 입력해야 합니다.")
            }
        }
    }
    
    private func authorizePhotoAccess() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            showSettingAlert()
        case .authorized:
            openPhotoLibrary()
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized { self.openPhotoLibrary() }
            }
        default:
            break
        }
    }
    
    private func openPhotoLibrary() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                imagePicker.sourceType = .photoLibrary
                imagePicker.modalPresentationStyle = .currentContext
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func showSettingAlert() {
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let alertVC = UIAlertController(
                title: "사진 접근 권한이 없습니다.",
                message: "사진 접근 허용은 '설정 > \(appName) > 사진'에서 하실 수 있습니다.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction (
                title: "확인",
                style: .default
            )
            alertVC.addAction(okAction)
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    private func isAllEntered() -> Bool {
        if !addRepresentativeImageButton.imageView!.image!.isEqual(UIImage(named: "imageAddIcon")),
           !(menuNameTextField.text?.isEmpty ?? true),
           categoryOpenButton.backgroundColor == .focusSkyBlue,
           !(amountTextField.text?.isEmpty ?? true),
           !(timeRequiredTextField.text?.isEmpty ?? true),
           ingredientTableView.numberOfRows(inSection: 0) > 1
        {
            return true
        }
        return false
    }
    
    private func changeNextButtonColor() {
        if isAllEntered() { nextButton.backgroundColor = .availableBlue }
        else { nextButton.backgroundColor = .disabledButtonGray }
    }
    
    func receiveDataFromSecondAddVC(addedCookingProcessList: [[Any?]]) {
        self.addedCookingProcessList = addedCookingProcessList
    }
    
    /* textField 글자수 제한 함수 */
    @objc func menuNameTextDidChange(noti: NSNotification) {
        if let text = menuNameTextField.text {
            limitTextLength(text, textField: self.menuNameTextField)
        }
    }
    
    @objc func amountTextDidChange(noti: NSNotification) {
        if let text = amountTextField.text {
            limitTextLength(text, textField: self.amountTextField)
        }
    }
    
    @objc func timeRequiredTextDidChange(noti: NSNotification) {
        if let text = timeRequiredTextField.text {
            limitTextLength(text, textField: self.timeRequiredTextField)
        }
    }
    
    private func limitTextLength(_ text: String, textField: UITextField) {
        let maxLength: Int
        if textField == self.menuNameTextField {
            maxLength = MENU_NAME_MAX_LENGTH
        } else {
            maxLength = GENERAL_MAX_LENGTH
        }
        
        if text.count >= maxLength {
            let fixedText = text[..<(text.index(text.startIndex, offsetBy: maxLength))]
            textField.text = fixedText + " "
            
            let when = DispatchTime.now() + 0.01
            DispatchQueue.main.asyncAfter(deadline: when) {
                textField.text = String(fixedText)
            }
        }
    }
    
    /* textField 입력 감지 함수 */
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            switch textField {
                case menuNameTextField:
                    menuNameView.backgroundColor = .focusSkyBlue
                case amountTextField:
                    servingLabel.textColor = .black
                    amountView.backgroundColor = .focusSkyBlue
                case timeRequiredTextField:
                    minuteLabel.textColor = .black
                    timeRequiredView.backgroundColor = .focusSkyBlue
                default: return
            }
        } else {
            switch textField {
                case menuNameTextField:
                    menuNameView.backgroundColor = .notEnteredStateColor
                case amountTextField:
                    servingLabel.textColor = .placeholderColor
                    amountView.backgroundColor = .notEnteredStateColor
                case timeRequiredTextField:
                    minuteLabel.textColor = .placeholderColor
                    timeRequiredView.backgroundColor = .notEnteredStateColor
                default: return
            }
        }
        changeNextButtonColor()
    }
}

extension UIViewController {
    func showBaseAlert(title: String, content: String, leadingConstant: Double? = nil, trailingConstant: Double? = nil) {
        let alertStoryboard = UIStoryboard(name: "Alert", bundle: nil)
        let baseAlertViewController = alertStoryboard.instantiateViewController(withIdentifier: "BaseAlertViewController") as! BaseAlertViewController
        baseAlertViewController.configure(title: title, content: content, leadingConstant: leadingConstant, trailingConstant: trailingConstant)
        baseAlertViewController.modalPresentationStyle = .overFullScreen
        baseAlertViewController.modalTransitionStyle = .crossDissolve
        present(baseAlertViewController, animated: true)
    }
}

extension AddRecipeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addRepresentativeImageButton.imageView?.contentMode = .scaleAspectFill
            addRepresentativeImageButton.setImage(image, for: .normal)
            changeNextButtonColor()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension AddRecipeViewController: UITableViewDelegate, UITableViewDataSource, DeleteButtonTappedDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0 :
            return RecipeCategory.allCases.count
        case 1:
            return addedIngredientList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0 :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCategoryCell", for: indexPath) as? RecipeCategoryTableViewCell else {return UITableViewCell()}
            
            cell.configure(categoryTitle: RecipeCategory.allCases[indexPath.row].rawValue)
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientCell", for: indexPath) as? RecipeIngredientTableViewCell else {return UITableViewCell()}
            
            cell.configure(indexPath: indexPath, name: addedIngredientList[indexPath.row][0], amount: addedIngredientList[indexPath.row][1])
            cell.selectionStyle = .none
            cell.deleteButtonTappedDelegate = self
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0 :
            UIView.animate(withDuration: 0.3) {
                self.categoryOpenButton.backgroundColor = .focusSkyBlue
                self.categoryTableView.backgroundColor = .focusTableViewSkyBlue
                self.categoryOpenImageView.image = UIImage(named: "recipeCategoryOpenIcon")
                self.changeNextButtonColor()
            }
            let selectedRecipeCategory = RecipeCategory.allCases[indexPath.row]
            let attributedTitle = NSAttributedString(string: selectedRecipeCategory.rawValue, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
            self.categoryOpenButton.setAttributedTitle(attributedTitle, for: .normal)
            self.categoryViewHeight.priority = UILayoutPriority(1000)
            self.isOpenCategoryView.toggle()
        default:
            return
        }
    }
    
    func tappedCellDeleteButton(indexPath: IndexPath) {
        ingredientTableView.beginUpdates()
        addedIngredientList.remove(at: indexPath.row)
        ingredientTableView.deleteRows(at: [indexPath], with: .none)
        ingredientTableView.endUpdates()
        ingredientTableView.reloadData()
        changeNextButtonColor()
    }
}

extension AddRecipeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class IntrinsicTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        return CGSize(width: self.contentSize.width, height: height)
    }
    
    override func layoutSubviews() {
        self.invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
}

protocol DeleteButtonTappedDelegate: AnyObject {
    func tappedCellDeleteButton(indexPath: IndexPath)
}

class CustomTableViewCell: UITableViewCell {
    weak var deleteButtonTappedDelegate: DeleteButtonTappedDelegate?
}

protocol ReceiveSecondDataDelegate: AnyObject {
    func receiveDataFromSecondAddVC(addedCookingProcessList: [[Any?]])
}
