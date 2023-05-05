//
//  AddRecipeViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/04.
//

import UIKit

class AddRecipeViewController: UIViewController {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryOpenButton: UIButton!
    @IBOutlet weak var categoryOpenImageView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var timeRequiredTextField: UITextField!
    private var isOpenCategoryView: Bool = false
    
    // font color, 스크롤뷰, 완료버튼 계속 떠있게
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        categoryTableView.separatorStyle = .none
    }
    
    private func setup() {
        amountTextField.delegate = self
        timeRequiredTextField.delegate = self
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        let categoryCell = UINib(nibName: "RecipeCategoryTableViewCell", bundle: nil)
        categoryTableView.register(categoryCell, forCellReuseIdentifier: "RecipeCategoryCell")
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
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapCategoryOpenBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.isOpenCategoryView {
                self.categoryViewHeight.priority = UILayoutPriority(1000)
                self.categoryOpenImageView.image = UIImage(named: "recipeCategoryOpenIcon")
            } else {
                self.categoryView.backgroundColor = .focusTableViewSkyBlue
                self.categoryViewHeight.priority = UILayoutPriority(250)
                self.categoryOpenImageView.image = UIImage(named: "recipeCategoryCloseIcon")
            }
            self.isOpenCategoryView.toggle()
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
    }
}

extension AddRecipeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 3
        guard let text = textField.text else { return true }
        
        if text.count >= maxLength { return false }
        return true
    }
}
