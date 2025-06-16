//
//  FoodEditViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/06.
//

import UIKit

class FoodEditViewController: UIViewController {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodDetailTextView: UITextView!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var ddayTextField: UITextField!
    @IBOutlet weak var foodCategoryTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    var food: Food?
    private let viewModel = FoodViewModel.shared
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFields()
        loadFoodData()
    }
    
    private func setupUI() {
        title = "음식 수정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                         target: self,
                                                         action: #selector(didTapCancelButton))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        foodImageView.addGestureRecognizer(tapGesture)
        foodImageView.isUserInteractionEnabled = true
    }
    
    private func setupTextFields() {
        foodNameTextField.delegate = self
        countTextField.delegate = self
        ddayTextField.delegate = self
        foodCategoryTextField.delegate = self
        
        foodNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        countTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        ddayTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        foodCategoryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func loadFoodData() {
        guard let food = food else { return }
        
        if let imageUrl = food.imgURL {
            foodImageView.kf.setImage(with: URL(string: imageUrl))
        }
        foodNameTextField.text = food.foodName
        foodDetailTextView.text = food.foodDetail
        countTextField.text = "\(food.count)"
        ddayTextField.text = "\(food.dday)"
        foodCategoryTextField.text = food.foodCategory
        
        updateCompleteButtonState()
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func textFieldDidChange() {
        updateCompleteButtonState()
    }
    
    private func updateCompleteButtonState() {
        let isNameValid = !(foodNameTextField.text?.isEmpty ?? true)
        let isCountValid = !(countTextField.text?.isEmpty ?? true)
        let isDdayValid = !(ddayTextField.text?.isEmpty ?? true)
        let isCategoryValid = !(foodCategoryTextField.text?.isEmpty ?? true)
        
        completeButton.isEnabled = isNameValid && isCountValid && isDdayValid && isCategoryValid
    }
    
    @IBAction func didTapCompleteButton(_ sender: Any) {
        guard let food = food,
              let foodName = foodNameTextField.text,
              let foodDetail = foodDetailTextView.text,
              let countText = countTextField.text,
              let ddayText = ddayTextField.text,
              let foodCategory = foodCategoryTextField.text,
              let count = Int(countText),
              let dday = Int(ddayText) else { return }
        
        if let image = selectedImage {
            viewModel.getUploadImageUrl(imageDir: .food, image: image) { [weak self] imageUrl in
                self?.updateFood(foodIdx: food.foodIdx,
                               foodName: foodName,
                               foodDetail: foodDetail,
                               count: count,
                               dday: dday,
                               foodCategory: foodCategory,
                               foodImage: imageUrl)
            }
        } else {
            updateFood(foodIdx: food.foodIdx,
                      foodName: foodName,
                      foodDetail: foodDetail,
                      count: count,
                      dday: dday,
                      foodCategory: foodCategory,
                      foodImage: food.imgURL)
        }
    }
    
    private func updateFood(foodIdx: Int, foodName: String, foodDetail: String, count: Int, dday: Int, foodCategory: String, foodImage: String?) {
        let userId = APIManger.shared.getUserId()
        viewModel.patchFood(foodIdx: foodIdx,
                          userId: userId,
                          foodName: foodName,
                          foodDetail: foodDetail,
                          count: count,
                          dday: dday,
                          foodCategory: foodCategory,
                          foodImage: foodImage) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

extension FoodEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FoodEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            foodImageView.image = image
            selectedImage = image
        }
        picker.dismiss(animated: true)
    }
} 