
import Observation

protocol UserSession: AnyObject {
    var currentUser: User? { get }
    var isAuthenticated: Bool { get }
    
    func getToken() -> String?
    func clear() throws
    func onError(error: Error)
    
    func storeSession(user: User, token: String) throws
    func restoreSession()
    func logout()
}

@Observable
class RealUserSession: UserSession {
    
    private let tokenProvider: TokenProvider
    private let userIdStorage: UserIdStorage
    private var status: Loading<User> = .notLoaded
    
    var currentUser: User? {
        self.status.loadedValue
    }
    
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    init(tokenProvider: TokenProvider, userIdStorage: UserIdStorage) {
        self.tokenProvider = tokenProvider
        self.userIdStorage = userIdStorage
    }
    
    func getToken() -> String? {
        guard let userId = currentUser?.id else {
            return nil
        }
        return try? tokenProvider.getToken(userId: userId)
    }
    
    // Call this when the App launches
    func restoreSession() {
        // A. Check if we have a saved ID in UserDefaults
        guard let userId = userIdStorage.getUserId() else {
            print("No user ID found. User is not logged in.")
            return
        }
        
        // B. Check if we have a valid token in Keychain for this ID
        guard let token = try? tokenProvider.getToken(userId: userId) else {
            print("Token missing or expired. Redirect to login.")
            logout()
            return
        }
        
        self.status = .loaded(.init(id: userId))
        
        // TODO: Fetch other info from DB
    }
    
    func logout() {
        if let userId = currentUser?.id ?? userIdStorage.getUserId() {
            try? tokenProvider.deleteToken(userId: userId)
        }
        status = .notLoaded
        userIdStorage.removeUserId()
        // Optionally clear local DB or keep it for multi-user switching
    }
    
    func storeSession(user: User, token: String) throws {
        status = .loaded(user)
        try tokenProvider.saveToken(token, userId: user.id)
        userIdStorage.save(userId: user.id)
        // TODO: Save user to local db if required
    }

    func clear() throws {
        if let userId = currentUser?.id {
            try tokenProvider.deleteToken(userId: userId)
        }
        status = .notLoaded
        userIdStorage.removeUserId()
    }
    
    func onError(error: Error) {
        status = .error(error)
    }
}
