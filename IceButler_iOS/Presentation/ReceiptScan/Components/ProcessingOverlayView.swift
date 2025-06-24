//
//  ProcessingOverlayView.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import UIKit

class ProcessingOverlayView: UIView {
    
    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemMaterial)
        return UIVisualEffectView(effect: effect)
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        return view
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "영수증 분석 중..."
        label.font = UIFont(name: "NanumSquareOTFB", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareOTF", size: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(named: "Blue2")
        progressView.trackTintColor = UIColor.systemGray5
        return progressView
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
        addSubview(blurView)
        addSubview(contentView)
        
        contentView.addSubview(activityIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(progressView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 280),
            contentView.heightAnchor.constraint(equalToConstant: 200),
            
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func updateProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
        
        let message: String
        switch progress {
        case 0.0..<0.3:
            message = "영수증 텍스트 읽는 중..."
        case 0.3..<0.7:
            message = "AI가 식품 정보 분석 중..."
        case 0.7..<1.0:
            message = "유통기한 계산 중..."
        default:
            message = "완료!"
        }
        
        messageLabel.text = message
    }
}