
import Foundation


class StubAuthenticationService: AuthenticationService {
    
    func login(username: String, password: String) async throws -> (User, String) {
        if username.lowercased() == "fail" {
            throw AuthError.invalidCredentials
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return (.init(id: "StubUser"), "myToken")
    }
    
    func logout() async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

