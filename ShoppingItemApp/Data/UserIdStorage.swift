
import Foundation

// Protocol for storing and retrieving the user ID
protocol UserIdStorage {
    func save(userId: String)
    func getUserId() -> String?
    func removeUserId()
}

// Concrete implementation using UserDefaults
class UserDefaultsUserIdStorage: UserIdStorage {
    private let userIdKey = "currentUserId"
    
    func save(userId: String) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }
    
    func removeUserId() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }
}

// Stub implementation for testing
class StubUserIdStorage: UserIdStorage {
    func save(userId: String) { }
    func getUserId() -> String? { return nil }
    func removeUserId() { }
}
