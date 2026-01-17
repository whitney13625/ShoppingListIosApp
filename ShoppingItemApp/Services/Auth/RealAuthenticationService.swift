
import Foundation

struct RealAuthenticationService: AuthenticationService {
    
    private let apiHost: String
    private let userSession: UserSession
    private let http: Http
    
    init(apiHost: String, userSession: UserSession) {
        self.apiHost = apiHost
        self.userSession = userSession
        self.http = Http(userSession: userSession)
    }
    
    private func uri(_ parts: String...) -> URL {
        return URL(string: "http://\(apiHost)/api/" + parts.joined(separator: "/"))!
    }
    
    func login(username: String, password: String) async throws {
        do {
            let url = uri("auth/login")
            let response: LoginResponse = try await http.performRequest(
                url, method: .POST,
                body: ["email": username, "password": password],
                authRequired: false
            )
            print("Received token: \(response.token), url: \(url.absoluteString)")
            try self.userSession.storeSession(user: .init(from: response.user), token: response.token)
        } catch {
            self.userSession.onError(error: error)
            throw error
        }
    }
    
    func logout() async throws {
        try self.userSession.clear()
    }
}

private struct LoginResponse: Codable {
    var token: String
    var user: UserDTO
}
