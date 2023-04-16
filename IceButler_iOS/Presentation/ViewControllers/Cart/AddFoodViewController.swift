//
//  AddFoodViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/07.
//

import UIKit

// MARK: 장바구니에서 플로팅 버튼을 탭하는 경우 나오는 '식품 추가' 화면
class AddFoodViewController: UIViewController {

    private let category = [
        "육류", "과일", "채소", "음료", "수산물", "반찬", "간식", "조미료", "가공식품", "기타"
    ]
    
    private var searchResults: [AddFoodResponseModel] = []
    private var selectedFoodNames: [String] = []
    private var selectedFoods: [AddFood] = []
    private var selectedCategory: String?
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var searchResultContainerView: UIView!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.backgroundColor = .signatureLightBlue
        self.tabBarController?.tabBar.isHidden = true
        
        setupNavigationBar()
        setupLayouts()
        setup()
    }
    
    // MARK: helper methods
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        CartService().postFoodsAdd(multifridgeIdx: 1, foods: self.selectedFoods)
    }
    
    @IBAction func didTapBackItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if let _ = searchTextField.text {
            searchResults.removeAll()
            getSearchResults(inputKeyword: searchTextField.text!)
        }
    }
    
    // MARK: helper methods
    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.signatureLightBlue
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
            statusBar?.backgroundColor = UIColor.signatureLightBlue
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    private func setupLayouts() {
        self.searchContainerView.layer.cornerRadius = 23
        self.searchTextField.borderStyle = .none
        self.completeButton.backgroundColor = .systemGray5
        self.completeButton.tintColor = .white
        self.completeButton.layer.cornerRadius = 23
        
        searchResultContainerView.layer.cornerRadius = 23
        searchResultContainerView.isHidden = true
        collectionView.isHidden = true
    }
    
    private func setup() {
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        let categoryCell = UINib(nibName: "FoodCategoryCollectionViewCell", bundle: nil)
        self.categoryCollectionView.register(categoryCell, forCellWithReuseIdentifier: "FoodCategoryCollectionViewCell")
        self.categoryCollectionView.tag = 0
        
        self.searchResultTableView.separatorStyle = .none
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let foodCell = UINib(nibName: "SelectedFoodNameCollectionViewCell", bundle: nil)
        self.collectionView.register(foodCell, forCellWithReuseIdentifier: "SelectedFoodNameCollectionViewCell")
        self.collectionView.tag = 1
        
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func getSearchResults(inputKeyword: String) {
        let queryParam = ["word":inputKeyword]
        APIManger.shared.getData(urlEndpointString: "/foods",
                                 responseDataType: [AddFoodResponseModel].self,
                                 parameter: queryParam,
                                 completionHandler: { [weak self] response in

            if response.data?.count ?? 0 > 0 {
                response.data?.forEach({ data in
                    self?.searchResults.append(data)
                    self?.searchResultTableView.reloadData()
                })
                if self?.searchResults.count ?? 0 > 0 {
                    self?.searchResultContainerView.isHidden = false
                } else {
                    self?.searchResultContainerView.isHidden = true
                }
                
            } else {
                self?.selfAddFood(foodName: (self?.searchTextField.text)!)
                let alert = UIAlertController(title: nil, message: "검색 결과가 없습니다!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
        })
    }
    
    private func checkSelectedFoodNamesCount() {
        if selectedFoodNames.count > 0 {
            completeButton.backgroundColor = UIColor.signatureBlue
            completeButton.isEnabled = true
        } else {
            completeButton.backgroundColor = UIColor.white
            completeButton.backgroundColor = .systemGray5
            completeButton.tintColor = .white
            completeButton.isEnabled = false
        }
    }
    
    private func addFoods(index: Int) {
        let name = self.searchResults[index].foodName
        let category = self.searchResults[index].foodCategory
        selectedFoods.append(AddFood(foodName: name, foodCategory: category))
    }
    
    private func selfAddFood(foodName: String) {
        if let category = selectedCategory {
            selectedFoods.append(AddFood(foodName: foodName, foodCategory: category))
            collectionView.reloadData()
            print(selectedFoods)
        }
    }
    
    // MARK: @objc methods
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 0 { searchContainerView.backgroundColor = .systemGray6 }
        else { searchContainerView.backgroundColor = .focusSkyBlue }
    }
}

extension AddFoodViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 { return self.category.count }
        else { return self.selectedFoodNames.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            // 카테고리 셀
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCategoryCollectionViewCell", for: indexPath) as? FoodCategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.setupLayout(title: category[indexPath.row])
            cell.delegate = self
            return cell
        } else if collectionView.tag == 1 {
            // 검색결과 탭을 통해 하위에 생성되는 "카테고리-상세식품명" 형태의 셀
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedFoodNameCollectionViewCell", for: indexPath) as? SelectedFoodNameCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            if searchResults.count > 0 {
                cell.setupLayout(title: "\(searchResults[indexPath.row].foodCategory!)-\(searchResults[indexPath.row].foodName!)")
            }
            cell.tag = indexPath.row
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension AddFoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return searchResults.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodSearchResultTableViewCell", for: indexPath) as? AddFoodSearchResultTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .none
        cell.resultLabel.text = searchResults[indexPath.row].foodName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.searchResultContainerView.isHidden = true
        self.collectionView.isHidden = false
        
        // TODO: 선택된 결과값의 카테고리/이름을 포함한 CV cell 추가 시키기
        // selectedFoodNames에 데이터 추가 -> cv reload
        if self.selectedFoodNames.count < 5 {
            selectedFoodNames.append(self.searchResults[indexPath.row].foodName!)
            self.collectionView.reloadData()
            self.checkSelectedFoodNamesCount()
            self.addFoods(index: indexPath.row)
            
        } else {
            let alert = UIAlertController(title: nil, message: "한 번에 최대 5가지의 식품만 추가가 가능합니다!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
}

extension AddFoodViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchResultContainerView.isHidden = true
        return true
    }
}

extension AddFoodViewController: FoodCategoryCellDelegate {
    func didTapCategoryButton(category: String) { selectedCategory = category }
}

extension AddFoodViewController: SelectedFoodCellDelegate {
    func didTapDeleteButton(index: Int) {
        selectedFoodNames.remove(at: index)
        collectionView.reloadData()
    }
}
