//
//  AuthenticationService.swift
//  ShoppingItemApp
//
//  Created by Gemini on 1/13/26.
//

import Foundation

protocol AuthenticationService {
    func login(credentials: (username: String, password: String)) async throws
}
