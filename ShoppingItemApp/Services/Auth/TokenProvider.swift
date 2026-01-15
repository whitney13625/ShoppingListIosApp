
protocol TokenProvider {
    func getToken(userId: String) throws -> String?
    func saveToken(_ token: String, userId: String) throws
    func deleteToken(userId: String) throws
}

class StubTokenManager: TokenProvider {
    func getToken(userId: String) throws -> String? { return nil }
    func saveToken(_ token: String, userId: String) throws {  }
    func deleteToken(userId: String) throws {  }
}
