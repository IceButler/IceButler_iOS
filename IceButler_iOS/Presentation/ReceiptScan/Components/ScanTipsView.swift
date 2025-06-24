//
//  ScanTipsView.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import UIKit

class ScanTipsView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "📱 촬영 팁"
        label.font = UIFont(name: "NanumSquareOTFB", size: 16)
        return label
    }()
    
    private let tipsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private let tips = [
        "• 영수증 전체가 화면에 들어오도록 촬영",
        "• 조명이 밝은 곳에서 촬영",
        "• 흔들림 없이 선명하게 촬영",
        "• 영수증이 구겨지지 않도록 펼쳐서 촬영"
    ]
    
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
        
        addSubview(titleLabel)
        addSubview(tipsStackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            tipsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tipsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tipsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tipsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        setupTips()
    }
    
    private func setupTips() {
        tips.forEach { tip in
            let tipLabel = UILabel()
            tipLabel.text = tip
            tipLabel.font = UIFont(name: "NanumSquareOTF", size: 14)
            tipLabel.textColor = .secondaryLabel
            tipLabel.numberOfLines = 0
            tipsStackView.addArrangedSubview(tipLabel)
        }
    }
}