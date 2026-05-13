
import SwiftUI

@propertyWrapper
struct FeatureFlag {
    
    @Environment(\.featureManager) private var featureManager: FeatureManager
    
    var key: String
    var defaultValue: Bool
    
    var wrappedValue: Bool {
        return featureManager.isEnabled(key) ?? defaultValue
    }
    
}
