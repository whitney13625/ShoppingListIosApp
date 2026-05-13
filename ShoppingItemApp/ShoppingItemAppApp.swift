//
//  ShoppingItemAppApp.swift
//  ShoppingItemApp
//
//  Created by Whitney on 31/12/2025.
//

import SwiftUI

@main
struct ShoppingItemAppApp: App {
    
    @State private var appState = AppState()
    
    private let featureManager = FeatureManager(config: [
        Features.isAdvancedSearchEnabled.rawValue: false,
        Features.isShareEnabled.rawValue: true
    ])
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(\.featureManager, featureManager)
                .task {
                    await appState.bootstrap()
                }
        }
    }
}
