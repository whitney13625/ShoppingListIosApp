//
//  LoginViewModel.swift
//  ShoppingItemApp
//
//  Created by Gemini on 1/13/26.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    
    private let authState: AuthState
    private let authenticationService: AuthenticationService
    
    
    init(authState: AuthState, authenticationService: AuthenticationService) {
        self.authState = authState
        self.authenticationService = authenticationService
    }
    
    func login() async {
        do {
            try await authenticationService.login(username: username, password: password)
            authState.isAuthenticated = true
            
        }
        catch {
            authState.isAuthenticated = false
        }
    }
}
