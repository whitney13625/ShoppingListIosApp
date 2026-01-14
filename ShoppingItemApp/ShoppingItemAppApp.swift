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
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .task {
                    await appState.bootstrap()
                }
        }
    }
}
