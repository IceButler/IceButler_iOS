//
//  ScanLimitIndicatorView.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import UIKit

class ScanLimitIndicatorView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iceButlerMainIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Free"
        label.font = UIFont(name: "NanumSquareOTFB", size: 14)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareOTF", size: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let upgradeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("업그레이드", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "Blue2")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "NanumSquareOTFB", size: 12)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 8
        
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(infoStackView)
        stackView.addArrangedSubview(UIView()) // Spacer
        stackView.addArrangedSubview(upgradeButton)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(countLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        upgradeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            upgradeButton.widthAnchor.constraint(equalToConstant: 80),
            upgradeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(remainingScans: Int, currentTier: SubscriptionTier) {
        titleLabel.text = currentTier.displayName
        
        if remainingScans == -1 {
            countLabel.text = "무제한 스캔"
        } else {
            countLabel.text = "남은 스캔: \(remainingScans)회"
        }
        
        upgradeButton.isHidden = currentTier != .free
    }
}