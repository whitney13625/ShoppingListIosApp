
import Foundation
import Observation

@MainActor
@Observable
class LoginViewModel {
    
    var username = ""
    var password = ""
    
    let authState: AuthState
    private let authenticationService: AuthenticationService
    
    
    init(authState: AuthState, authenticationService: AuthenticationService) {
        self.authState = authState
        self.authenticationService = authenticationService
    }
    
    func login() async throws {
        do {
            try await authenticationService.login(username: username, password: password)
            authState.status = .loaded(true)
        }
        catch {
            authState.status = .error(error)
            throw error
        }
    }
}
