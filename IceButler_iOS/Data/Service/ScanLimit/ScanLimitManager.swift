//
//  ScanLimitManager.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - ScanLimitManager
class ScanLimitManager {
    static let shared = ScanLimitManager()
    
    private let currentTierRelay = BehaviorRelay<SubscriptionTier>(value: .free)
    private let remainingScansRelay = BehaviorRelay<Int>(value: 5)
    
    var currentTier: SubscriptionTier {
        return currentTierRelay.value
    }
    
    var remainingScans: Int {
        return remainingScansRelay.value
    }
    
    private let userDefaults = UserDefaults.standard
    private let disposeBag = DisposeBag()
    
    private enum Keys {
        static let scanCount = "monthly_scan_count"
        static let lastResetDate = "last_reset_date"
        static let subscriptionTier = "subscription_tier"
    }
    
    private init() {
        loadData()
        setupMonthlyReset()
    }
    
    // MARK: - Public Methods
    func canScan() -> Bool {
        switch currentTier {
        case .free:
            return remainingScans > 0
        case .pro:
            return remainingScans > 0
        case .premium:
            return true // Unlimited
        }
    }
    
    func consumeScan() -> Bool {
        guard canScan() else { return false }
        
        switch currentTier {
        case .free, .pro:
            let newCount = remainingScans - 1
            remainingScansRelay.accept(newCount)
            saveData()
        case .premium:
            break // Unlimited, no need to consume
        }
        
        return true
    }
    
    func getRemainingScans() -> Int {
        switch currentTier {
        case .free, .pro:
            return remainingScans
        case .premium:
            return -1 // Represents unlimited
        }
    }
    
    func upgradeSubscription(to tier: SubscriptionTier) {
        currentTierRelay.accept(tier)
        resetMonthlyLimit()
        saveData()
    }
    
    // MARK: - Private Methods
    private func loadData() {
        // Load subscription tier
        if let tierString = userDefaults.string(forKey: Keys.subscriptionTier),
           let tier = SubscriptionTier(rawValue: tierString) {
            currentTierRelay.accept(tier)
        }
        
        // Check if monthly reset is needed
        if shouldResetMonthly() {
            resetMonthlyLimit()
        } else {
            // Load remaining scans
            let savedCount = userDefaults.integer(forKey: Keys.scanCount)
            let newRemaining = max(0, currentTier.monthlyScans - savedCount)
            remainingScansRelay.accept(newRemaining)
        }
    }
    
    private func saveData() {
        userDefaults.set(currentTier.rawValue, forKey: Keys.subscriptionTier)
        
        let usedScans = currentTier.monthlyScans - remainingScans
        userDefaults.set(usedScans, forKey: Keys.scanCount)
        
        userDefaults.set(Date(), forKey: Keys.lastResetDate)
    }
    
    private func shouldResetMonthly() -> Bool {
        guard let lastResetDate = userDefaults.object(forKey: Keys.lastResetDate) as? Date else {
            return true // First time, should reset
        }
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let lastResetMonth = calendar.component(.month, from: lastResetDate)
        
        let currentYear = calendar.component(.year, from: Date())
        let lastResetYear = calendar.component(.year, from: lastResetDate)
        
        return currentYear != lastResetYear || currentMonth != lastResetMonth
    }
    
    private func resetMonthlyLimit() {
        let newScans: Int
        switch currentTier {
        case .free:
            newScans = 5
        case .pro:
            newScans = 20
        case .premium:
            newScans = -1 // Unlimited
        }
        
        remainingScansRelay.accept(newScans)
        userDefaults.set(0, forKey: Keys.scanCount)
        userDefaults.set(Date(), forKey: Keys.lastResetDate)
    }
    
    private func setupMonthlyReset() {
        // Check for monthly reset every day at midnight
        Observable<Int>.timer(.seconds(0), period: .seconds(24 * 60 * 60), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if self?.shouldResetMonthly() == true {
                    self?.resetMonthlyLimit()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Development/Testing Methods
    func resetForTesting() {
        userDefaults.removeObject(forKey: Keys.scanCount)
        userDefaults.removeObject(forKey: Keys.lastResetDate)
        userDefaults.removeObject(forKey: Keys.subscriptionTier)
        
        currentTierRelay.accept(.free)
        remainingScansRelay.accept(5)
    }
    
    func simulateSubscription(_ tier: SubscriptionTier) {
        upgradeSubscription(to: tier)
    }
}