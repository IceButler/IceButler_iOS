//
//  ReceiptScanReactor.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import Foundation
// import ReactorKit
// import RxSwift
import UIKit

// TODO: ReactorKit 패키지 추가 후 활성화
// final class ReceiptScanReactor: Reactor {
final class ReceiptScanReactor {
    
    // MARK: - Action
    enum Action {
        case viewDidLoad
        case startScan
        case captureImage(UIImage)
        case addItemsToFridge
        case dismissError
        case resetState
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setLoading(Bool)
        case setScanProgress(Float)
        case setRemainingScans(Int)
        case setCurrentTier(SubscriptionTier)
        case setCanScan(Bool)
        case setShowCamera(Bool)
        case setShowResults(Bool)
        case setShowSubscriptionPaywall(Bool)
        case setProcessedItems([FoodItem])
        case setError(String?)
    }
    
    // MARK: - State
    struct State {
        var currentTier: SubscriptionTier = .free
        var remainingScans: Int = 5
        var canScan: Bool = true
        var isProcessing: Bool = false
        var scanProgress: Float = 0.0
        var showCamera: Bool = false
        var showResults: Bool = false
        var showSubscriptionPaywall: Bool = false
        var processedItems: [FoodItem] = []
        var errorMessage: String?
    }
    
    let initialState: State
    
    // MARK: - Services
    private let ocrService = ReceiptOCRService.shared
    private let gptService = GPTAnalysisService.shared
    private let scanLimitManager = ScanLimitManager.shared
    
    // MARK: - Initialization
    init() {
        self.initialState = State()
    }
    
    // TODO: ReactorKit 활성화 후 주석 해제
    /*
    // MARK: - Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                .just(.setCurrentTier(scanLimitManager.currentTier)),
                .just(.setRemainingScans(scanLimitManager.getRemainingScans())),
                .just(.setCanScan(scanLimitManager.canScan()))
            ])
            
        case .startScan:
            guard scanLimitManager.canScan() else {
                return .just(.setShowSubscriptionPaywall(true))
            }
            return .just(.setShowCamera(true))
            
        case let .captureImage(image):
            return .concat([
                .just(.setShowCamera(false)),
                .just(.setLoading(true)),
                .just(.setScanProgress(0.0)),
                processReceiptImage(image)
            ])
            
        case .addItemsToFridge:
            // TODO: 실제 냉장고에 아이템 추가 로직
            return .concat([
                .just(.setShowResults(false)),
                .just(.setProcessedItems([])),
                updateScanLimit()
            ])
            
        case .dismissError:
            return .just(.setError(nil))
            
        case .resetState:
            return .concat([
                .just(.setShowResults(false)),
                .just(.setProcessedItems([])),
                .just(.setLoading(false)),
                .just(.setScanProgress(0.0)),
                .just(.setError(nil))
            ])
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isProcessing = isLoading
            
        case let .setScanProgress(progress):
            newState.scanProgress = progress
            
        case let .setRemainingScans(scans):
            newState.remainingScans = scans
            
        case let .setCurrentTier(tier):
            newState.currentTier = tier
            
        case let .setCanScan(canScan):
            newState.canScan = canScan
            
        case let .setShowCamera(show):
            newState.showCamera = show
            
        case let .setShowResults(show):
            newState.showResults = show
            
        case let .setShowSubscriptionPaywall(show):
            newState.showSubscriptionPaywall = show
            
        case let .setProcessedItems(items):
            newState.processedItems = items
            
        case let .setError(error):
            newState.errorMessage = error
        }
        
        return newState
    }
    
    // MARK: - Private Methods
    private func processReceiptImage(_ image: UIImage) -> Observable<Mutation> {
        return .create { observer in
            // 스캔 횟수 차감
            guard self.scanLimitManager.consumeScan() else {
                observer.onNext(.setLoading(false))
                observer.onNext(.setShowSubscriptionPaywall(true))
                observer.onCompleted()
                return Disposables.create()
            }
            
            // OCR 처리
            observer.onNext(.setScanProgress(0.3))
            
            let ocrDisposable = self.ocrService.extractText(from: image)
                .subscribe(
                    onNext: { ocrText in
                        observer.onNext(.setScanProgress(0.7))
                        
                        // GPT 분석
                        let gptDisposable = self.gptService.analyzeFoodItems(from: ocrText)
                            .subscribe(
                                onNext: { foodItems in
                                    observer.onNext(.setScanProgress(1.0))
                                    observer.onNext(.setLoading(false))
                                    observer.onNext(.setProcessedItems(foodItems))
                                    observer.onNext(.setShowResults(true))
                                    observer.onCompleted()
                                },
                                onError: { error in
                                    observer.onNext(.setLoading(false))
                                    observer.onNext(.setError(error.localizedDescription))
                                    observer.onCompleted()
                                }
                            )
                        
                        return gptDisposable
                    },
                    onError: { error in
                        observer.onNext(.setLoading(false))
                        observer.onNext(.setError(error.localizedDescription))
                        observer.onCompleted()
                    }
                )
            
            return Disposables.create {
                ocrDisposable.dispose()
            }
        }
    }
    
    private func updateScanLimit() -> Observable<Mutation> {
        return .concat([
            .just(.setCurrentTier(scanLimitManager.currentTier)),
            .just(.setRemainingScans(scanLimitManager.getRemainingScans())),
            .just(.setCanScan(scanLimitManager.canScan()))
        ])
    }
    */
}