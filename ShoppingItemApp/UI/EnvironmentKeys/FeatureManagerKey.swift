
import SwiftUI

private struct FeatureManagerKey: EnvironmentKey {
    static let defaultValue: FeatureManager = FeatureManager(config: [:])
}

extension EnvironmentValues {
    var featureManager: FeatureManager {
        get { self[FeatureManagerKey.self] }
        set { self[FeatureManagerKey.self] = newValue }
    }
}
