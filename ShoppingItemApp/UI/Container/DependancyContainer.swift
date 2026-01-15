
struct DependencyContainer {
    
    let appConfig: AppConfig
    
    let authState: AuthState
    let tokenProvider: TokenProvider
    
    let authenticationService: AuthenticationService
    let networkService: NetworkService
    
    static func live() -> DependencyContainer {
        let config = AppConfig.fromInfoPList()
        let tokenProvider = KeychainTokenManager()
        return DependencyContainer(
            appConfig: config,
            authState: .init(),
            tokenProvider: tokenProvider,
            authenticationService: RealAuthenticationService(apiHost: config.API_HOST_NAME, tokenProvider: tokenProvider),
            networkService: RealNetworkService(apiHost: config.API_HOST_NAME, tokenProvider: tokenProvider)
        )
    }

    static func dev() -> DependencyContainer {
        let config = AppConfig.fromInfoPList()
        let tokenProvider = KeychainTokenManager()
        return DependencyContainer(
            appConfig: config,
            authState: .init(),
            tokenProvider: tokenProvider,
            authenticationService: RealAuthenticationService(apiHost: config.API_HOST_NAME, tokenProvider: tokenProvider),
            networkService: RealNetworkService(apiHost: config.API_HOST_NAME, tokenProvider: tokenProvider)
        )
    }
    
    static func stub() -> DependencyContainer {
        return DependencyContainer(
            appConfig: .fromInfoPList(),
            authState: .init(),
            tokenProvider: StubTokenManager(),
            authenticationService: StubAuthenticationService(),
            networkService: StubNetworkService()
        )
    }
}
