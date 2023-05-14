//
//  AddRecipeSecondViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/06.
//

import UIKit
import Photos

class AddRecipeSecondViewController: UIViewController, ReceiveFirstDataDelegate {
    private let TEXTVIEW_MAX_LENGTH = 200

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cookingProcessLabel: UILabel!
    @IBOutlet weak var cookingProcessTableView: UITableView!
    @IBOutlet weak var addCookingProcessImageButton: UIButton!
    @IBOutlet weak var cookingProcessTextView: UITextView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var cookingProcessStackViewTopConstarintToCookingProcessTableView: NSLayoutConstraint!
    
    private var addedCookingProcessList: [[Any?]] = []
    private let stackViewImagePicker = UIImagePickerController()
    private let cellImagePicker = UIImagePickerController()
    
    weak var secondDateDelegate: ReceiveSecondDataDelegate?
    private var representativeImage: UIImage!
    private var menuName: String!
    private var category: String!
    private var amount: Int!
    private var timeRequired: Int!
    private var ingredientList: [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setupLayout()
        changeCompletionButtonColor()
    }
    
    private func setup() {
        hideKeyboardWhenTapScreen()
        cookingProcessTextView.delegate = self
        cookingProcessTableView.delegate = self
        cookingProcessTableView.dataSource = self
        cookingProcessTableView.rowHeight = UITableView.automaticDimension
        
        let cookingProcessCell = UINib(nibName: "RecipeCookingProcessCell", bundle: nil)
        cookingProcessTableView.register(cookingProcessCell, forCellReuseIdentifier: "RecipeCookingProcessCell")
    }
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .navigationColor
        
        let title = UILabel()
        title.text = "레시피 추가"
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
        // label
        cookingProcessLabel.textColor = .textDeepBlue
        // tableView
        if addedCookingProcessList.count > 0 {
            cookingProcessStackViewTopConstarintToCookingProcessTableView.priority = UILayoutPriority(1000)
        }
        cookingProcessTableView.separatorStyle = .none
        // addImageButton
        addCookingProcessImageButton.setImage(UIImage(named: "imageAddIcon"), for: .normal)
        addCookingProcessImageButton.imageView?.contentMode = .scaleAspectFill
        addCookingProcessImageButton.layer.cornerRadius = 10
        addCookingProcessImageButton.layer.masksToBounds = true
        // textView
        cookingProcessTextView.text = "200자 이내"
        cookingProcessTextView.textColor = .placeholderColor
        cookingProcessTextView.textContainerInset = UIEdgeInsets(top: 12, left: 13, bottom: 12, right: 13);
        cookingProcessTextView.layer.cornerRadius = 10
        cookingProcessTextView.layer.masksToBounds = true
        // completionButton
        completionButton.layer.cornerRadius = completionButton.frame.height / 2
        completionButton.layer.masksToBounds = true
        completionButton.backgroundColor = .disabledButtonGray
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        secondDateDelegate?.receiveDataFromSecondAddVC(addedCookingProcessList: addedCookingProcessList)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapAddImageButton(_ sender: Any) {
        authorizePhotoAccess()
    }
    
    @IBAction func didTapAddCookingProcessButton(_ sender: Any) {
        if !cookingProcessTextView.text!.isEmpty {
            if addCookingProcessImageButton.imageView!.image!.isEqual(UIImage(named: "imageAddIcon")) {
                addedCookingProcessList.append([nil, cookingProcessTextView.text!])
            } else {
                addedCookingProcessList.append([addCookingProcessImageButton.imageView?.image, cookingProcessTextView.text!])
            }
            cookingProcessStackViewTopConstarintToCookingProcessTableView.priority = UILayoutPriority(1000)
            cookingProcessTableView.reloadData()
            scrollView.invalidateIntrinsicContentSize()
            changeCompletionButtonColor()
        }
    }
    
    @IBAction func didTapCompletionButton(_ sender: Any) {
        Task { @MainActor in
            if completionButton.backgroundColor == .availableBlue {
                let isSuccess = try await RecipeViewModel.shared.postRecipe(recipeImg: representativeImage,
                                                  recipeName: menuName,
                                                  category: category,
                                                  amount: amount,
                                                  timeRequired: timeRequired,
                                                  ingredientList: ingredientList,
                                                  cookingProcessList: addedCookingProcessList)
                if isSuccess {
                    let alert = UIAlertController(title: "성공", message: "레시피 등록에 성공했습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                        // TODO: 마이레시피로 이동
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: "레시피 등록에 실패했습니다. 다시 시도해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
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
    
    private func authorizePhotoAccess(indexPath: IndexPath) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            showSettingAlert()
        case .authorized:
            openPhotoLibrary(indexPath: indexPath)
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized { self.openPhotoLibrary(indexPath: indexPath) }
            }
        default:
            break
        }
    }
    
    private func openPhotoLibrary() {
        DispatchQueue.main.async {
            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                self.stackViewImagePicker.sourceType = .photoLibrary
                self.stackViewImagePicker.modalPresentationStyle = .currentContext
                self.stackViewImagePicker.delegate = self
                self.present(self.stackViewImagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func openPhotoLibrary(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.cellImagePicker.view.tag = indexPath.row
            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                self.cellImagePicker.sourceType = .photoLibrary
                self.cellImagePicker.modalPresentationStyle = .currentContext
                self.cellImagePicker.delegate = self
                self.present(self.cellImagePicker, animated: true, completion: nil)
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
        if cookingProcessTableView.numberOfRows(inSection: 0) > 1 { return true }
        return false
    }
    
    private func changeCompletionButtonColor() {
        if isAllEntered() { completionButton.backgroundColor = .availableBlue }
        else { completionButton.backgroundColor = .disabledButtonGray }
    }
    
    private func changeCellImage(image: UIImage, index: Int) {
        addedCookingProcessList[index][0] = image
        cookingProcessTableView.reloadData()
    }
    
    func receiveDataFromFirstAddVC(addedCookingProcessList: [[Any?]], representativeImage: UIImage, menuName: String, category: String, amount: Int, timeRequired: Int, addedIngredientList: [[String]]) {
        self.addedCookingProcessList = addedCookingProcessList
        self.representativeImage = representativeImage
        self.menuName = menuName
        self.category = category
        self.amount = amount
        self.timeRequired = timeRequired
        self.ingredientList = addedIngredientList
    }
}

extension AddRecipeSecondViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            switch picker {
            case stackViewImagePicker:
                addCookingProcessImageButton.imageView?.contentMode = .scaleAspectFill
                addCookingProcessImageButton.setImage(image, for: .normal)
                changeCompletionButtonColor()
            case cellImagePicker:
                changeCellImage(image: image, index: picker.view.tag)
            default:
                return
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
}

extension AddRecipeSecondViewController: UITableViewDelegate, UITableViewDataSource, DeleteButtonTappedDelegate, AddImageButtonTappedDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedCookingProcessList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCookingProcessCell", for: indexPath) as? RecipeCookingProcessCell else {return UITableViewCell()}
        
        cell.configure(indexPath: indexPath, image: addedCookingProcessList[indexPath.row][0] as? UIImage, description: addedCookingProcessList[indexPath.row][1]! as! String)
        cell.selectionStyle = .none
        cell.deleteButtonTappedDelegate = self
        cell.addImageButtonTappedDelegate = self
        
        return cell
    }
    
    func tappedCellAddImageButton(indexPath: IndexPath) {
        authorizePhotoAccess(indexPath: indexPath)
    }
    
    func tappedCellDeleteButton(indexPath: IndexPath) {
        cookingProcessTableView.beginUpdates()
        addedCookingProcessList.remove(at: indexPath.row)
        cookingProcessTableView.deleteRows(at: [indexPath], with: .none)
        cookingProcessTableView.endUpdates()
        cookingProcessTableView.reloadData()
        changeCompletionButtonColor()
    }
}

extension AddRecipeSecondViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderColor {
            textView.textColor = UIColor.black
            textView.text = nil
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "200자 이내"
            textView.textColor = .placeholderColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 200
    }
}

extension UIViewController {
    func hideKeyboardWhenTapScreen() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

protocol AddImageButtonTappedDelegate: AnyObject {
    func tappedCellAddImageButton(indexPath: IndexPath)
}

protocol ReceiveFirstDataDelegate: AnyObject {
    func receiveDataFromFirstAddVC(addedCookingProcessList: [[Any?]], representativeImage: UIImage, menuName: String, category: String, amount: Int, timeRequired: Int, addedIngredientList: [[String]])
}
