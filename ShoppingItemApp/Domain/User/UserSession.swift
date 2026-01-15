
import Observation

protocol UserSession: AnyObject {
    var currentUser: User? { get }
    var isAuthenticated: Bool { get }
    
    func getToken() -> String?
    func storeSession(user: User, token: String) throws
    func clear() throws
    func onError(error: Error)
}

@Observable
class RealUserSession: UserSession {
    
    private let tokenProvider: TokenProvider
    private var status: Loading<User> = .notLoaded
    
    var currentUser: User? {
        self.status.loadedValue
    }
    
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func getToken() -> String? {
        guard let userId = currentUser?.id else {
            return nil
        }
        return try? tokenProvider.getToken(userId: userId)
    }
    
    func storeSession(user: User, token: String) throws {
        status = .loaded(user)
        try tokenProvider.saveToken(token, userId: user.id)
        // TODO: Save to local database
    }

    func clear() throws {
        status = .notLoaded
        if let userId = currentUser?.id {
            try tokenProvider.deleteToken(userId: userId)
        }
        // TODO: Clean local database
    }
    
    func onError(error: Error) {
        status = .error(error)
    }
}
