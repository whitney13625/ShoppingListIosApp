
import Foundation


class StubAuthenticationService: AuthenticationService {
    
    func checkSession() async -> Bool {
        return false
    }
    
    func login(username: String, password: String) async throws {
        if username.lowercased() == "fail" {
            throw AuthError.invalidCredentials
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
    }
}

