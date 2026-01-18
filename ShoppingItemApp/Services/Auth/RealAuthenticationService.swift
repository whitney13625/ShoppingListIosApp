
import Foundation

struct RealAuthenticationService: AuthenticationService {
    
    private let apiHost: String
    private let http: HttpProtocol
    
    init(apiHost: String, http: HttpProtocol) {
        self.apiHost = apiHost
        self.http = http
    }
    
    private func uri(_ parts: String...) -> URL {
        return URL(string: "http://\(apiHost)/api/" + parts.joined(separator: "/"))!
    }
    
    func login(username: String, password: String) async throws -> (User, String) {
        let url = uri("auth/login")
        let response: LoginResponse = try await http.performRequest(
            url, method: .POST,
            body: ["email": username, "password": password],
            authRequired: false
        )
        print("Received token: \(response.token), url: \(url.absoluteString)")
        return (.init(from: response.user), response.token)
    }
    
    func logout() async throws {
        // TODO: Notify backend
    }
}

private struct LoginResponse: Codable {
    var token: String
    var user: UserDTO
}
