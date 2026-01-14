//
//  AuthenticationService.swift
//  ShoppingItemApp
//
//  Created by Gemini on 1/13/26.
//

import Foundation

protocol AuthenticationService {
    func checkSession() async -> Bool
    func login(username: String, password: String) async throws
    func logout() async
}
