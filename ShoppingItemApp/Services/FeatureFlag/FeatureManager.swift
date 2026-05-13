// FeatureManager.swift
import Foundation

class FeatureManager {
    
    // Simulate config from API or Firebase Remote Config
    private var remoteConfig: [String: Bool]
    
    init(config: [String: Bool] = [:]) {
        self.remoteConfig = config
    }
    
    func isEnabled(_ key: String) -> Bool? {
        return remoteConfig[key]
    }
}

enum Features: String {
    case isShareEnabled = "isShareEnabled"
    case isAdvancedSearchEnabled = "isAdvancedSearchEnabled"
}

