
import Foundation
import Observation

@MainActor
@Observable
class LoginViewModel {
    
    var username = ""
    var password = ""
    
    let userSession: UserSession
    private let authenticationService: AuthenticationService
    
    
    init(userSession: UserSession, authenticationService: AuthenticationService) {
        self.userSession = userSession
        self.authenticationService = authenticationService
    }
    
    func login() async throws {
        do {
            try await authenticationService.login(username: username, password: password)
        }
        catch {
            throw error
        }
    }
}
