// FeatureManager.swift
import Foundation

class FeatureManager {
    static let shared = FeatureManager()
    
    // Simulate config from API or Firebase Remote Config
    private var remoteConfig: [String: Bool] = [
        Features.isAdvancedSearchEnabled.rawValue: false,
        Features.isShareEnabled.rawValue: true
    ]
    
    func isEnabled(_ key: String) -> Bool? {
        return remoteConfig[key]
    }
}

enum Features: String {
    case isShareEnabled = "isShareEnabled"
    case isAdvancedSearchEnabled = "isAdvancedSearchEnabled"
}
