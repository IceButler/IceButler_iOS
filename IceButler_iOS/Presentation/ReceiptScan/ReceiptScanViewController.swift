//
//  ReceiptScanViewController.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import UIKit
// import ReactorKit
// import RxSwift
// import RxCocoa
// import SnapKit

// TODO: ReactorKit 패키지 추가 후 활성화
// final class ReceiptScanViewController: UIViewController, View {
final class ReceiptScanViewController: UIViewController {
    
    // typealias Reactor = ReceiptScanReactor
    
    // MARK: - Properties
    // var disposeBag = DisposeBag()
    private var reactor: ReceiptScanReactor?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iceButlerMainIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "영수증 스캔"
        label.font = UIFont(name: "NanumSquareOTFB", size: 24)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "영수증을 촬영하면 자동으로\n냉장고에 식품이 추가됩니다"
        label.font = UIFont(name: "NanumSquareOTF", size: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let scanLimitView = ScanLimitIndicatorView()
    
    private let scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "Blue2")
        button.layer.cornerRadius = 12
        button.setTitle("영수증 촬영하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareOTFB", size: 18)
        return button
    }()
    
    private let tipsView = ScanTipsView()
    private let processingOverlay = ProcessingOverlayView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupReactor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reactor?.action.onNext(.viewDidLoad)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "영수증 스캔"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerStackView)
        contentView.addSubview(scanLimitView)
        contentView.addSubview(scanButton)
        contentView.addSubview(tipsView)
        
        headerStackView.addArrangedSubview(iconImageView)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(subtitleLabel)
        
        view.addSubview(processingOverlay)
        processingOverlay.isHidden = true
        
        // Button actions
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        scanLimitView.translatesAutoresizingMaskIntoConstraints = false
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        tipsView.translatesAutoresizingMaskIntoConstraints = false
        processingOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // HeaderStackView
            headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // IconImageView
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // ScanLimitView
            scanLimitView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 32),
            scanLimitView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            scanLimitView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            scanLimitView.heightAnchor.constraint(equalToConstant: 60),
            
            // ScanButton
            scanButton.topAnchor.constraint(equalTo: scanLimitView.bottomAnchor, constant: 24),
            scanButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            scanButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            scanButton.heightAnchor.constraint(equalToConstant: 60),
            
            // TipsView
            tipsView.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 24),
            tipsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            tipsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            tipsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            // ProcessingOverlay
            processingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            processingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            processingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            processingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupReactor() {
        reactor = ReceiptScanReactor()
        // TODO: ReactorKit 바인딩 추가
    }
    
    // MARK: - Actions
    @objc private func scanButtonTapped() {
        presentCamera()
    }
    
    // MARK: - Private Methods
    private func presentCamera() {
        let cameraViewController = CameraViewController()
        cameraViewController.delegate = self
        present(cameraViewController, animated: true)
    }
    
    private func presentResults(items: [FoodItem]) {
        let resultsViewController = ScanResultsViewController()
        resultsViewController.configure(with: items)
        resultsViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: resultsViewController)
        present(navigationController, animated: true)
    }
    
    private func presentSubscriptionPaywall() {
        let alert = UIAlertController(
            title: "스캔 횟수 초과",
            message: "이번 달 무료 스캔 횟수를 모두 사용했습니다.\nPro 구독으로 업그레이드하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "업그레이드", style: .default) { _ in
            // TODO: 구독 화면으로 이동
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "오류",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true)
    }
    
    // TODO: ReactorKit 바인딩 추가
    /*
    // MARK: - Bind
    func bind(reactor: ReceiptScanReactor) {
        // View -> Reactor
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        scanButton.rx.tap
            .map { Reactor.Action.startScan }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Reactor -> View
        reactor.state.map { $0.remainingScans }
            .distinctUntilChanged()
            .bind(to: scanLimitView.rx.remainingScans)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentTier }
            .distinctUntilChanged()
            .bind(to: scanLimitView.rx.currentTier)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.canScan }
            .distinctUntilChanged()
            .bind(to: scanButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: processingOverlay.rx.isVisible)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.scanProgress }
            .distinctUntilChanged()
            .bind(to: processingOverlay.rx.progress)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showCamera }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.presentCamera()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showResults }
            .distinctUntilChanged()
            .filter { $0 }
            .withLatestFrom(reactor.state.map { $0.processedItems })
            .subscribe(onNext: { [weak self] items in
                self?.presentResults(items: items)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showSubscriptionPaywall }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.presentSubscriptionPaywall()
            })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.errorMessage }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(message: error)
            })
            .disposed(by: disposeBag)
    }
    */
}

// MARK: - CameraViewControllerDelegate
extension ReceiptScanViewController: CameraViewControllerDelegate {
    func cameraViewController(_ viewController: CameraViewController, didCaptureImage image: UIImage) {
        viewController.dismiss(animated: true) { [weak self] in
            // TODO: reactor?.action.onNext(.captureImage(image))
            // 임시로 직접 처리
            self?.processImage(image)
        }
    }
    
    func cameraViewControllerDidCancel(_ viewController: CameraViewController) {
        viewController.dismiss(animated: true)
    }
    
    private func processImage(_ image: UIImage) {
        // 임시 구현 - ReactorKit 활성화 후 제거
        processingOverlay.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.processingOverlay.isHidden = true
            
            // Mock 데이터로 결과 표시
            let mockItems = [
                FoodItem(name: "우유", category: .dairy, expiryDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(), storageType: .refrigerator),
                FoodItem(name: "바나나", category: .fruit, expiryDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(), storageType: .pantry)
            ]
            
            self?.presentResults(items: mockItems)
        }
    }
}

// MARK: - ScanResultsViewControllerDelegate
extension ReceiptScanViewController: ScanResultsViewControllerDelegate {
    func scanResultsViewController(_ viewController: ScanResultsViewController, didConfirmItems items: [FoodItem]) {
        viewController.dismiss(animated: true) { [weak self] in
            // TODO: reactor?.action.onNext(.addItemsToFridge)
            print("냉장고에 \(items.count)개 아이템 추가")
        }
    }
    
    func scanResultsViewControllerDidCancel(_ viewController: ScanResultsViewController) {
        viewController.dismiss(animated: true) { [weak self] in
            // TODO: reactor?.action.onNext(.resetState)
        }
    }
}