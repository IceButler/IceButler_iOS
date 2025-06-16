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
import JGProgressHUD

protocol FoodAddDelegate: AnyObject {
    func moveToFoodAddSelect()
}

protocol FoodAddSceneDelegate {
    func showToast(message: String)
}

class FoodAddViewController: UIViewController {    
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodDetailTextView: UITextView!
    @IBOutlet weak var foodDetailPlaceholder: UILabel!
    @IBOutlet weak var foodCountTextField: UITextField!
    @IBOutlet weak var foodDdayTextField: UITextField!
    @IBOutlet weak var foodCategoryTextField: UITextField!
    @IBOutlet weak var foodCategoryPlaceholder: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    private var foodImage: UIImage?
    private var foodIdx: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInitialData()
        setupFoodImage()
    }
    
    private func setupUI() {
        addButton.isEnabled = false
        addButton.backgroundColor = .systemGray4
        
        foodNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        foodDetailTextView.delegate = self
        foodCountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        foodDdayTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        foodCategoryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupInitialData() {
        if FoodViewModel.shared.isEditFood == true {
            guard let editFood = FoodViewModel.shared.getFood() else {return}
            foodNameTextField.text = editFood.foodName
            foodDetailTextView.text = editFood.foodDetail
            foodDetailTextView.textColor = .black
            foodDetailPlaceholder.isHidden = true
            foodCountTextField.text = String(editFood.count)
            foodDdayTextField.text = String(editFood.dday)
            foodCategoryTextField.text = editFood.foodCategory
            foodCategoryTextField.textColor = .black
            foodCategoryPlaceholder.isHidden = true
            foodImage = editFood.foodImage
            foodImageView.image = editFood.foodImage
            foodImageView.contentMode = .scaleAspectFill
            foodImageView.clipsToBounds = true
            foodImageView.layer.cornerRadius = 8
            foodImageView.layer.borderWidth = 1
            foodImageView.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    private func setupFoodImage() {
        FoodViewModel.shared.foodImage { [weak self] imgUrl in
            guard let self = self else { return }
            if let imgUrl = imgUrl {
                self.foodImageView.kf.setImage(with: URL(string: imgUrl))
                self.foodImageView.contentMode = .scaleAspectFill
                self.foodImageView.clipsToBounds = true
                self.foodImageView.layer.cornerRadius = 8
                self.foodImageView.layer.borderWidth = 1
                self.foodImageView.layer.borderColor = UIColor.systemGray4.cgColor
            }
        }
    }
    
    @objc private func textFieldDidChange() {
        if let name = foodNameTextField.text, !name.isEmpty,
           let count = foodCountTextField.text, !count.isEmpty,
           let dday = foodDdayTextField.text, !dday.isEmpty,
           let category = foodCategoryTextField.text, !category.isEmpty {
            addButton.isEnabled = true
            addButton.backgroundColor = .availableBlue
        } else {
            addButton.isEnabled = false
            addButton.backgroundColor = .systemGray4
        }
    }
    
    @IBAction func didTapAddButton(_ sender: UIButton) {
        let userId = APIManger.shared.getUserId()
        
        if let foodImage = foodImage {
            FoodViewModel.shared.getUploadImageUrl(imageDir: ImageDir.Food, image: foodImage) { [weak self] imgUrl in
                guard let self = self else { return }
                if FoodViewModel.shared.isEditFood {
                    FoodViewModel.shared.patchFood(foodIdx: self.foodIdx, userId: userId,
                                                 foodName: self.foodNameTextField.text!,
                                                 foodDetail: self.foodDetailTextView.text,
                                                 count: Int(self.foodCountTextField.text!)!,
                                                 dday: Int(self.foodDdayTextField.text!)!,
                                                 foodCategory: self.foodCategoryTextField.text!,
                                                 foodImage: imgUrl) {
                        FoodViewModel.shared.isEditFood = false
                        FoodViewModel.shared.getFoodDetail(foodIdx: self.foodIdx)
                        self.dismiss(animated: true)
                    }
                } else {
                    FoodViewModel.shared.postFood(userId: userId,
                                                foodName: self.foodNameTextField.text!,
                                                foodDetail: self.foodDetailTextView.text,
                                                count: Int(self.foodCountTextField.text!)!,
                                                dday: Int(self.foodDdayTextField.text!)!,
                                                foodCategory: self.foodCategoryTextField.text!,
                                                foodImage: imgUrl) {
                        self.dismiss(animated: true)
                    }
                }
            }
        } else {
            if FoodViewModel.shared.isEditFood {
                FoodViewModel.shared.patchFood(foodIdx: foodIdx, userId: userId,
                                             foodName: foodNameTextField.text!,
                                             foodDetail: foodDetailTextView.text,
                                             count: Int(foodCountTextField.text!)!,
                                             dday: Int(foodDdayTextField.text!)!,
                                             foodCategory: foodCategoryTextField.text!,
                                             foodImage: nil) {
                    FoodViewModel.shared.isEditFood = false
                    FoodViewModel.shared.getFoodDetail(foodIdx: foodIdx)
                    dismiss(animated: true)
                }
            } else {
                FoodViewModel.shared.postFood(userId: userId,
                                            foodName: foodNameTextField.text!,
                                            foodDetail: foodDetailTextView.text,
                                            count: Int(foodCountTextField.text!)!,
                                            dday: Int(foodDdayTextField.text!)!,
                                            foodCategory: foodCategoryTextField.text!,
                                            foodImage: nil) {
                    dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension FoodAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        foodDetailPlaceholder.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            foodDetailPlaceholder.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.textColor = .black
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
                
                if isEdit {
                    FoodViewModel.shared.foodImage { imgUrl in
                        cell.configure(imageUrl: imgUrl ?? "")
                    }
                    
                    if foodImage != nil {
                        cell.setImage(image: foodImage!)
                    }
                }else {
                    if foodImage != nil {
                        cell.setImage(image: foodImage!)
                    } else {
                        cell.showFoodImageAddIcon()
                    }
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
                selectImage()
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
    
    

