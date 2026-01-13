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
    @Published var isAuthenticated = false
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService = StubAuthenticationService()) {
        self.authenticationService = authenticationService
    }
    
    func login() async {
        let credentials = (username: username, password: password)
        isAuthenticated = await authenticationService.login(credentials: credentials)
    }
}
