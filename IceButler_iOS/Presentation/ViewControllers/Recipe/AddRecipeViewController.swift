//
//  AddRecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/04.
//

import UIKit

class AddRecipeViewController: UIViewController {
    private let MENU_NAME_MAX_LENGTH = 20
    private let GENERAL_MAX_LENGTH = 3
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryOpenButton: UIButton!
    @IBOutlet weak var categoryOpenImageView: UIImageView!
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var timeRequiredTextField: UITextField!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var ingredientAmountTextField: UITextField!
    
    private var isOpenCategoryView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setupLayout()
    }
    
    private func setup() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        let categoryCell = UINib(nibName: "RecipeCategoryTableViewCell", bundle: nil)
        categoryTableView.register(categoryCell, forCellReuseIdentifier: "RecipeCategoryCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(menuNameTextDidChange), name: UITextField.textDidChangeNotification, object: menuNameTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(amountTextDidChange), name: UITextField.textDidChangeNotification, object: amountTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(timeRequiredTextDidChange), name: UITextField.textDidChangeNotification, object: timeRequiredTextField)
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
        setupPlaceholder()
        // 2. corner radius
        
        
        
        // tableview
//        categoryOpenButton.layer.cornerRadius = 10
        // 3. textField/카테고리 미입력/입력 시 색깔 지정 -> 회색, 파란색
        categoryTableView.separatorStyle = .none
        
        // 4. label/button color
        // 5. 카테고리 버튼 타이틀 정렬

        // 인분, 분: 미입력-> placeholder색, 입력-> 검은색
        // 재료명, 양 모두 입력하고 +버튼 누를 시 파란색으로 스택뷰 생기게
        // 대표사진 선택
        // 카테고리 선택 시 버튼 타이틀에 설정(폰트, 정렬)
        // 모든 사항 입력시 다음 버튼 활성화(뭐하나 입력될 때마다 확인해봐야 하나?)
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
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
            self.isOpenCategoryView.toggle()
        }
    }
    
    @IBAction func didTapAddIngredientButton(_ sender: Any) {
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        // 모든 데이터 넘겨야함
        // 두번째 추가 화면에서 다시 back 버튼 눌렀을 때 두번째 화면 데이터 다시 첫번째로 넘겨서 보존하기
        guard let addRecipeSecondViewController = storyboard!.instantiateViewController(withIdentifier: "AddRecipeSecondViewController") as? AddRecipeSecondViewController else { return }
        self.navigationController?.pushViewController(addRecipeSecondViewController, animated: true)
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
}

extension AddRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCategoryCell", for: indexPath) as? RecipeCategoryTableViewCell else {return UITableViewCell()}
            
            cell.configure(categoryTitle: RecipeCategory.allCases[indexPath.row].rawValue)
            cell.selectionStyle = .none
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.categoryOpenButton.backgroundColor = .focusSkyBlue
            self.categoryOpenImageView.image = UIImage(named: "recipeCategoryOpenIcon")
        }
        let selectedRecipeCategory = RecipeCategory.allCases[indexPath.row]
        let attributedTitle = NSAttributedString(string: selectedRecipeCategory.rawValue, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        self.categoryOpenButton.setAttributedTitle(attributedTitle, for: .normal)
        self.categoryViewHeight.priority = UILayoutPriority(1000)
        self.isOpenCategoryView.toggle()
    }
}
