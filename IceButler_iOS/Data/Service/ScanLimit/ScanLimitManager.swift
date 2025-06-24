//
//  ScanLimitManager.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import Foundation
import Combine

// MARK: - ScanLimitManager
class ScanLimitManager: ObservableObject {
    static let shared = ScanLimitManager()
    
    @Published var currentTier: SubscriptionTier = .free
    @Published var remainingScans: Int = 5
    
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
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
            remainingScans -= 1
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
        currentTier = tier
        resetMonthlyLimit()
        saveData()
    }
    
    // MARK: - Private Methods
    private func loadData() {
        // Load subscription tier
        if let tierString = userDefaults.string(forKey: Keys.subscriptionTier),
           let tier = SubscriptionTier(rawValue: tierString) {
            currentTier = tier
        }
        
        // Check if monthly reset is needed
        if shouldResetMonthly() {
            resetMonthlyLimit()
        } else {
            // Load remaining scans
            let savedCount = userDefaults.integer(forKey: Keys.scanCount)
            remainingScans = max(0, currentTier.monthlyScans - savedCount)
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
        switch currentTier {
        case .free:
            remainingScans = 5
        case .pro:
            remainingScans = 20
        case .premium:
            remainingScans = -1 // Unlimited
        }
        
        userDefaults.set(0, forKey: Keys.scanCount)
        userDefaults.set(Date(), forKey: Keys.lastResetDate)
    }
    
    private func setupMonthlyReset() {
        // Check for monthly reset every day at midnight
        Timer.publish(every: 24 * 60 * 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if self?.shouldResetMonthly() == true {
                    self?.resetMonthlyLimit()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Development/Testing Methods
    func resetForTesting() {
        userDefaults.removeObject(forKey: Keys.scanCount)
        userDefaults.removeObject(forKey: Keys.lastResetDate)
        userDefaults.removeObject(forKey: Keys.subscriptionTier)
        
        currentTier = .free
        remainingScans = 5
    }
    
    func simulateSubscription(_ tier: SubscriptionTier) {
        upgradeSubscription(to: tier)
    }
}