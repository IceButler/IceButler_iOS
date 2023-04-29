//
//  SearchFoodVIewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/28.
//

import UIKit

class SearchFoodVIewController: UIViewController {
    
    @IBOutlet weak var searchFoodCollectionView: UICollectionView!
    @IBOutlet weak var serachResultLabel: UILabel!
    
    private var delegate: FoodAddDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupNavgationBar()
        setupObserver()
    }
    
    private func setup() {
        searchFoodCollectionView.delegate = self
        searchFoodCollectionView.dataSource = self
        
        let cell = UINib(nibName: "FoodCollectionViewCell", bundle: nil)
        searchFoodCollectionView.register(cell, forCellWithReuseIdentifier: "FoodCollectionViewCell")
    }
    
    func setDelegate(delegate: FoodAddDelegate) {
        self.delegate = delegate
    }
    
    
    private func setupObserver() {
        FoodViewModel.shared.isSearchFoodList { result in
            if result {
                self.searchFoodCollectionView.isHidden = false
                self.serachResultLabel.isHidden = true
                
                UIView.transition(with: self.searchFoodCollectionView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                    self.searchFoodCollectionView.reloadData()},
                                  completion: nil)
            }else {
                self.searchFoodCollectionView.isHidden = true
                self.serachResultLabel.isHidden = false
            }
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
        
        self.navigationItem.leftBarButtonItem = backItem
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "식품명",
            attributes: [.foregroundColor: UIColor.placeholderColor]
        )
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        
    }
    
    @objc private func backToScene() {
        navigationController?.popViewController(animated: true)
        delegate?.moveToFoodAddSelect()
    }


}


extension SearchFoodVIewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FoodViewModel.shared.searchFoodListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as! FoodCollectionViewCell
        
        FoodViewModel.shared.searchFoodImg(index: indexPath.row, store: &cell.cancellabels) { foodImg in
            cell.setFoodImg(foodImg: foodImg)
        }
        
        FoodViewModel.shared.searchFoodName(index: indexPath.row, store: &cell.cancellabels) { foodName in
            cell.setFoodName(foodName: foodName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodAddVC = UIStoryboard(name: "FoodAdd", bundle: nil).instantiateViewController(withIdentifier: "FoodAddViewController") as! FoodAddViewController
        
        self.navigationController?.pushViewController(foodAddVC, animated: true)
    }
    
    
}

extension SearchFoodVIewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        <#code#>
    }
    
    
}
