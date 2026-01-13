
struct DependencyContainer {
    
    let authState: AuthState
    
    let authenticationService: AuthenticationService
    let networkService: NetworkService
    
    static func live() -> DependencyContainer {
        DependencyContainer(
            authState: .init(),
            authenticationService: RealAuthenticationService(),
            networkService: RealNetworkService()
        )
    }

    static func stub() -> DependencyContainer {
        DependencyContainer(
            authState: .init(),
            authenticationService: StubAuthenticationService(),
            networkService: StubNetworkService()
        )
    }
}
