//
//  SearchFoodVIewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/28.
//

import UIKit

enum SearchCategory {
    case Food
    case Fridge
}



class SearchFoodViewController: UIViewController {
    
    @IBOutlet weak var searchFoodCollectionView: UICollectionView!
    @IBOutlet weak var serachResultLabel: UILabel!
    
    private var delegate: BarCodeAddProtocol?
    private var fridgeDelegate: FoodAddDelegate?
    private var isFirst = true
    private var searchCategory: SearchCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupLayout()
        setupNavgationBar()
        setupObserver()
    }
    
    private func setup() {
        searchFoodCollectionView.delegate = self
        searchFoodCollectionView.dataSource = self
        
        let cell = UINib(nibName: "FoodCell", bundle: nil)
        searchFoodCollectionView.register(cell, forCellWithReuseIdentifier: "FoodCell")
        
        if searchCategory == .Food {
            serachResultLabel.text = "식품을 검색해보세요!"
        }else if searchCategory == .Fridge {
            serachResultLabel.text = "냉장고 내 식품을 검색해보세요!"
        }
        
    }
    
    private func setupLayout() {
        searchFoodCollectionView.collectionViewLayout = FoodCollectionViewLeftAlignFlowLayout()
        
        if let flowLayout = searchFoodCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func setupObserver() {
        if searchCategory == .Food {
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
        }else if searchCategory == .Fridge {
            FoodViewModel.shared.isFridgeSearchFoodList { result in
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
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 315, height: 0))
        
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "식품명",
            attributes: [.foregroundColor: UIColor.placeholderColor]
        )
        
        searchBar.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    func setDelegate(delegate: BarCodeAddProtocol) {
        self.delegate = delegate
    }
    
    func setFridgeDelegate(fridgeDelegate: FoodAddDelegate) {
        self.fridgeDelegate = fridgeDelegate
    }
    
    
    @objc private func backToScene() {
        if searchCategory == .Food {
            FoodViewModel.shared.deleteAll()
            self.navigationController?.popViewController(animated: true)
            self.fridgeDelegate?.moveToFoodAddSelect()
        }else if searchCategory == .Fridge {
            FoodViewModel.shared.deleteAll()
            self.navigationController?.popViewController(animated: true)
        }
    }


}


extension SearchFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchCategory == .Food {
            return FoodViewModel.shared.searchFoodListCount()
        }else {
            return FoodViewModel.shared.fridgeSearchFoodListCount()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        if searchCategory == .Food {
            FoodViewModel.shared.searchFoodImg(index: indexPath.row, store: &cell.cancellabels) { foodImg in
                cell.setFoodImage(foodImage: foodImg)
            }
            
            FoodViewModel.shared.searchFoodName(index: indexPath.row, store: &cell.cancellabels) { foodName in
                cell.setFoodName(foodName: foodName)
            }
            
            cell.foodDdayLabel.isHidden = true
        }else if searchCategory == .Fridge {
            FoodViewModel.shared.fridgeSearchFoodImg(index: indexPath.row, store: &cell.cancellabels) { foodImg in
                cell.setFoodImage(foodImage: foodImg)
            }
            
            FoodViewModel.shared.fridgeSearchFoodName(index: indexPath.row, store: &cell.cancellabels) { foodName in
                cell.setFoodName(foodName: foodName)
            }
            
            FoodViewModel.shared.fridgeSearchFoodDay(index: indexPath.row, store: &cell.cancellabels) { day in
                cell.setDday(foodDday: day)
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchCategory == .Food {
            FoodViewModel.shared.selectSearchFood(index: indexPath.row)

            let foodAddVC = UIStoryboard(name: "FoodAdd", bundle: nil).instantiateViewController(withIdentifier: "FoodAddViewController") as! FoodAddViewController
            
            self.navigationController?.pushViewController(foodAddVC, animated: true)
        }else {
            FoodViewModel.shared.selectFridgeSearchFood(index: indexPath.row)
            
            let foodDetailVC = UIStoryboard(name: "FoodDetail", bundle: nil).instantiateViewController(withIdentifier: "FoodDetailViewController") as! FoodDetailViewController
            
            self.navigationController?.pushViewController(foodDetailVC, animated: true)
        }
      
    }
    
}

extension SearchFoodViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let word = searchBar.text {
            if searchCategory == .Food {
                FoodViewModel.shared.getSearchFood(word: word)
            }else {
                FoodViewModel.shared.getFridgeSearchFood(word: word)
            }
        }
    }
    
}


extension SearchFoodViewController {
    func setSearchCategory(searchCategory: SearchCategory) {
        self.searchCategory = searchCategory
    }
}
