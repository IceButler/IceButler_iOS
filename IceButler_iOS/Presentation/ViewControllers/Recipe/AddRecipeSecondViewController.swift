//
//  AddRecipeSecondViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/06.
//

import UIKit

class AddRecipeSecondViewController: UIViewController {
    private let TEXTVIEW_MAX_LENGTH = 200

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cookingProcessLabel: UILabel!
    @IBOutlet weak var cookingProcessTableView: UITableView!
    @IBOutlet weak var addCookingProcessImageButton: UIButton!
    @IBOutlet weak var cookingProcessTextView: UITextView!
    @IBOutlet weak var completionButton: UIButton!
    
    @IBOutlet weak var cookingProcessStackViewTopConstarintToCookingProcessTableView: NSLayoutConstraint!
    
    private var addedCookingProcessList: [[String?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setupLayout()
    }
    
    private func setup() {
        // TODO: textView 200자 글자수 제한
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
        cookingProcessTableView.separatorStyle = .none
        // addImageButton
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapAddImageButton(_ sender: Any) {
        // TODO: 조리 과정 사진 추가
    }
    
    @IBAction func didTapAddCookingProcessButton(_ sender: Any) {
        // 이미지는 추가하지 않아도 됨, cell에서 텍스트 편집은 안 돼도(유저인터랙션 어쩌구 false), 사진은 추가할 수 있도록 해야함
        if !cookingProcessTextView.text!.isEmpty {
            if ((addCookingProcessImageButton.imageView?.image?.isEqual(UIImage(named: "imageAddIcon"))) != nil) {
                addedCookingProcessList.append([nil, cookingProcessTextView.text!])
            } else {
                // TODO: 추가된 이미지 리스트에 넣기
            }
            cookingProcessStackViewTopConstarintToCookingProcessTableView.priority = UILayoutPriority(1000)
        }
        
        cookingProcessTableView.reloadData()
        scrollView.invalidateIntrinsicContentSize()
    }
}

extension AddRecipeSecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedCookingProcessList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCookingProcessCell", for: indexPath) as? RecipeCookingProcessCell else {return UITableViewCell()}
        
        cell.configure(image: addedCookingProcessList[indexPath.row][0], description: addedCookingProcessList[indexPath.row][1]!)
        cell.selectionStyle = .none
        
        return cell
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
