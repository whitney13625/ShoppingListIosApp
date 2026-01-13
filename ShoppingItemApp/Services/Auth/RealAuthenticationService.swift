
struct RealAuthenticationService: AuthenticationService {
    
    func checkSession() async -> Bool {
        return false
    }
    
    func login(username: String, password: String) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
    }
}
