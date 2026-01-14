
import Foundation
import Observation

@MainActor
@Observable
class LoginViewModel {
    
    var username = ""
    var password = ""
    
    private let authState: AuthState
    private let authenticationService: AuthenticationService
    
    
    init(authState: AuthState, authenticationService: AuthenticationService) {
        self.authState = authState
        self.authenticationService = authenticationService
    }
    
    func login() async {
        do {
            try await authenticationService.login(username: username, password: password)
            authState.isAuthenticated = true
            
        }
        catch {
            authState.isAuthenticated = false
        }
    }
}
