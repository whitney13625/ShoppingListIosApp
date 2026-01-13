//
//  StubAuthenticationService.swift
//  ShoppingItemApp
//
//  Created by Gemini on 1/13/26.
//

import Foundation

struct StubAuthenticationService: AuthenticationService {
    func login(credentials: (username: String, password: String)) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
    }
}
