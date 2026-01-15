
import Foundation


class StubAuthenticationService: AuthenticationService {
    
    private let userSession: UserSession
    
    init(userSession: UserSession) {
        self.userSession = userSession
    }
    
    func checkSession() async -> Bool {
        return false
    }
    
    func login(username: String, password: String) async throws {
        if username.lowercased() == "fail" {
            throw AuthError.invalidCredentials
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        try userSession.storeSession(user: .init(id: "123"), token: "mock_token")
    }
    
    func logout() async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

