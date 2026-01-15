
import Foundation

struct RealAuthenticationService: AuthenticationService {
    
    private let apiHost: String
    private let tokenProvider: TokenProvider
    private let http: Http = .init()
    
    init(apiHost: String, tokenProvider: TokenProvider) {
        self.apiHost = apiHost
        self.tokenProvider = tokenProvider
    }
    
    private func uri(_ parts: String...) -> URL {
        return URL(string: "http://\(apiHost)/api/" + parts.joined(separator: "/"))!
    }
    
    func checkSession() async -> Bool {
        return false
    }
    
    func login(username: String, password: String) async throws {
        let response: LoginResponse = try await http.performRequest( uri("login"), method: .POST)
        self.tokenProvider.saveToken(response.token)
    }
    
    func logout() async {
        tokenProvider.deleteToken()
    }
}

private struct LoginResponse: Codable {
    var token: String
    var user: UserDTO
}
