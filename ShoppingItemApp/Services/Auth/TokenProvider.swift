
protocol TokenProvider {
    func getToken() -> String?
    func saveToken(_ token: String)
    func deleteToken()
}

class KeychainTokenManager: TokenProvider {
    func getToken() -> String? { return nil }
    func saveToken(_ token: String) {  }
    func deleteToken() {  }
}

class StubTokenManager: TokenProvider {
    func getToken() -> String? { return nil }
    func saveToken(_ token: String) {  }
    func deleteToken() {  }
}
