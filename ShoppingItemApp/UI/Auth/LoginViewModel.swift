
import Foundation
import Observation

@MainActor
@Observable
class LoginViewModel {
    
    var username = ""
    var password = ""
    
    private let userSession: UserSession
    private let authenticationService: AuthenticationService
    
    init(userSession: UserSession, authenticationService: AuthenticationService) {
        self.userSession = userSession
        self.authenticationService = authenticationService
    }
    
    func login() async throws {
        do {
            let (user, token) = try await authenticationService.login(username: username, password: password)
            try self.userSession.storeSession(user: user, token: token)
        } catch {
            self.userSession.onError(error: error)
            throw error
        }
    }
}
