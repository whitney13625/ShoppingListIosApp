
import Foundation

@propertyWrapper
struct FeatureFlag {
    var key: String
    var defaultValue: Bool
    
    var wrappedValue: Bool {
        return FeatureManager.shared.isEnabled(key) ?? defaultValue
    }
    
}
