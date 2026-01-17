
import Foundation

protocol AuthenticationService {
    func login(username: String, password: String) async throws
    func logout() async throws
}

enum AuthError: Error {
    case invalidCredentials
    case userNotFound
}
