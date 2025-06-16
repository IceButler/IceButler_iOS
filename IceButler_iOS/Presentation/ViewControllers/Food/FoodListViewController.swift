//
//  FoodListViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/06.
//

import UIKit

class FoodListViewController: UIViewController {
    
    @IBOutlet weak var foodListTableView: UITableView!
    
    private let viewModel = FoodViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFoodList()
    }
    
    private func setupUI() {
        title = "음식 목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                          target: self,
                                                          action: #selector(didTapAddButton))
    }
    
    private func setupTableView() {
        foodListTableView.delegate = self
        foodListTableView.dataSource = self
        foodListTableView.register(UINib(nibName: "FoodListCell", bundle: nil),
                                 forCellReuseIdentifier: "FoodListCell")
    }
    
    private func loadFoodList() {
        let userId = APIManger.shared.getUserId()
        viewModel.getFoodList(userId: userId)
    }
    
    @objc private func didTapAddButton() {
        let storyboard = UIStoryboard(name: "Food", bundle: nil)
        guard let foodAddVC = storyboard.instantiateViewController(withIdentifier: "FoodAddViewController") as? FoodAddViewController else { return }
        navigationController?.pushViewController(foodAddVC, animated: true)
    }
}

extension FoodListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodListCell", for: indexPath) as? FoodListCell else {
            return UITableViewCell()
        }
        
        let food = viewModel.foodList[indexPath.row]
        cell.configure(with: food)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let food = viewModel.foodList[indexPath.row]
        let storyboard = UIStoryboard(name: "Food", bundle: nil)
        guard let foodDetailVC = storyboard.instantiateViewController(withIdentifier: "FoodDetailViewController") as? FoodDetailViewController else { return }
        foodDetailVC.foodIdx = food.foodIdx
        navigationController?.pushViewController(foodDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let food = viewModel.foodList[indexPath.row]
            let userId = APIManger.shared.getUserId()
            
            viewModel.deleteFood(foodIdx: food.foodIdx, userId: userId) { [weak self] in
                self?.foodListTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
} 