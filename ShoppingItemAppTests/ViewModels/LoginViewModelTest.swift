
import Testing
@testable import ShoppingItemApp

struct LoginViewModelTest {

    @Test(arguments: [
        (user: User(id: "Mock_User"), token: "Mock_Token")
    ])
    func test_Login_Successfully(user: User, token: String) async throws {
        let userSession = MockUserSession()
        let authService = MockAuthService()
        
        let viewModel = await LoginViewModel(userSession: userSession, authenticationService: authService)
        
        authService.setSuccess(user: user, token: token)
        
       try await viewModel.login()
        
        #expect(authService.user?.id == user.id)
        #expect(authService.token == token)
        #expect(userSession.isAuthenticated)
        #expect(userSession.getToken() == token)
    }
    
    @Test
    func test_Login_Wrong_Credential() async throws {
        let userSession = MockUserSession()
        let authService = MockAuthService()
        let expectedError = AuthError.invalidCredentials
        
        let viewModel = await LoginViewModel(userSession: userSession, authenticationService: authService)
        
        authService.setFail(error: expectedError)
        
        await #expect(throws: expectedError) {
            let _ = try await viewModel.login()
        }
        #expect(!userSession.isAuthenticated)
        #expect(userSession.getToken() == nil)
    }

}

private class MockUserSession: UserSession {
    
    var currentUser: User?
    private var token: String?
    
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    func getToken() -> String? {
        token
    }
    
    func clear() throws {
        currentUser = nil
    }
    
    func onError(error: any Error) {
        
    }
    
    func storeSession(user: User, token: String) throws {
        self.currentUser = user
        self.token = token
    }
    
    func restoreSession() {
        
    }
    
    func logout() {
        
    }
    
    
}



private class MockAuthService: AuthenticationService {
    
    private var errorToShow: Error?
    var user: User?
    var token: String?
    
    func setSuccess(user: User, token: String) {
        self.user = user
        self.token = token
    }
    
    func setFail(error: Error) {
        errorToShow = AuthError.invalidCredentials
    }
    
    func login(username: String, password: String) async throws -> (User, String) {
        if let errorToShow {
            throw errorToShow
        }
        return (user!, token!)
    }
    
    func logout() async throws {
        
    }
    
    
}
