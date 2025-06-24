//
//  ScanResultsViewController.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import UIKit

protocol ScanResultsViewControllerDelegate: AnyObject {
    func scanResultsViewController(_ viewController: ScanResultsViewController, didConfirmItems items: [FoodItem])
    func scanResultsViewControllerDidCancel(_ viewController: ScanResultsViewController)
}

class ScanResultsViewController: UIViewController {
    
    weak var delegate: ScanResultsViewControllerDelegate?
    private var foodItems: [FoodItem] = []
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "스캔 결과"
        label.font = UIFont(name: "NanumSquareOTFB", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인식된 식품들을 확인하고 냉장고에 추가하세요"
        label.font = UIFont(name: "NanumSquareOTF", size: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareOTFB", size: 16)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("냉장고에 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareOTFB", size: 16)
        button.backgroundColor = UIColor(named: "Blue2")
        button.layer.cornerRadius = 12
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "스캔 결과"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FoodItemTableViewCell.self, forCellReuseIdentifier: "FoodItemCell")
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            
            buttonStackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 56),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    func configure(with items: [FoodItem]) {
        self.foodItems = items
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.updateConfirmButton()
        }
    }
    
    private func updateConfirmButton() {
        let selectedItems = foodItems.filter { $0.isSelected }
        confirmButton.isEnabled = !selectedItems.isEmpty
        confirmButton.backgroundColor = selectedItems.isEmpty ? UIColor.systemGray3 : UIColor(named: "Blue2")
        
        let title = selectedItems.isEmpty ? "냉장고에 추가" : "선택한 \(selectedItems.count)개 추가"
        confirmButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        delegate?.scanResultsViewControllerDidCancel(self)
    }
    
    @objc private func confirmTapped() {
        let selectedItems = foodItems.filter { $0.isSelected }
        delegate?.scanResultsViewController(self, didConfirmItems: selectedItems)
    }
}

// MARK: - UITableViewDataSource
extension ScanResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath) as! FoodItemTableViewCell
        cell.configure(with: foodItems[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ScanResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = "인식된 식품 (\(foodItems.count)개)"
        label.font = UIFont(name: "NanumSquareOTFB", size: 16)
        label.textColor = .label
        
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - FoodItemTableViewCellDelegate
extension ScanResultsViewController: FoodItemTableViewCellDelegate {
    func foodItemCell(_ cell: FoodItemTableViewCell, didToggleSelection isSelected: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        foodItems[indexPath.row] = FoodItem(
            id: foodItems[indexPath.row].id,
            name: foodItems[indexPath.row].name,
            category: foodItems[indexPath.row].category,
            expiryDate: foodItems[indexPath.row].expiryDate,
            storageType: foodItems[indexPath.row].storageType,
            isSelected: isSelected
        )
        updateConfirmButton()
    }
}

// MARK: - FoodItemTableViewCell
class FoodItemTableViewCell: UITableViewCell {
    
    weak var delegate: FoodItemTableViewCellDelegate?
    private var foodItem: FoodItem?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = UIColor(named: "Blue2")
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareOTFB", size: 16)
        label.textColor = .label
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareOTF", size: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let expiryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareOTF", size: 12)
        return label
    }()
    
    private let storageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareOTF", size: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(checkboxButton)
        containerView.addSubview(nameLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(expiryLabel)
        containerView.addSubview(storageLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        expiryLabel.translatesAutoresizingMaskIntoConstraints = false
        storageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            checkboxButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            checkboxButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            categoryLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            expiryLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 8),
            expiryLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            
            storageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            storageLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor)
        ])
        
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    func configure(with item: FoodItem) {
        self.foodItem = item
        
        nameLabel.text = item.name
        categoryLabel.text = item.category.displayName
        storageLabel.text = item.storageType.displayName
        
        checkboxButton.isSelected = item.isSelected
        
        // 유통기한 색상 설정
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        expiryLabel.text = formatter.string(from: item.expiryDate)
        
        switch item.expiryStatus {
        case .expired:
            expiryLabel.textColor = .systemRed
        case .expiringSoon:
            expiryLabel.textColor = .systemOrange
        case .fresh:
            expiryLabel.textColor = .systemGreen
        }
    }
    
    @objc private func checkboxTapped() {
        guard let foodItem = foodItem else { return }
        let newSelection = !foodItem.isSelected
        checkboxButton.isSelected = newSelection
        delegate?.foodItemCell(self, didToggleSelection: newSelection)
    }
}

// MARK: - FoodItemTableViewCellDelegate
protocol FoodItemTableViewCellDelegate: AnyObject {
    func foodItemCell(_ cell: FoodItemTableViewCell, didToggleSelection isSelected: Bool)
}