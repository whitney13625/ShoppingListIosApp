//
//  ShoppingItemAppApp.swift
//  ShoppingItemApp
//
//  Created by Whitney on 31/12/2025.
//

import SwiftUI

@main
struct ShoppingItemAppApp: App {
    
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            if loginViewModel.isAuthenticated {
                ContentView()
            } else {
                LoginView(viewModel: loginViewModel)
            }
        }
    }
}
