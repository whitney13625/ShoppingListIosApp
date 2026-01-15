
struct DependencyContainer {
    
    let appConfig: AppConfig
    
    let userSession: UserSession
    let tokenProvider: TokenProvider
    
    let authenticationService: AuthenticationService
    let networkService: NetworkService
    
    static func live() -> DependencyContainer {
        let config = AppConfig.fromInfoPList()
        let tokenProvider = KeychainTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        return DependencyContainer(
            appConfig: config,
            userSession: userSession,
            tokenProvider: tokenProvider,
            authenticationService: RealAuthenticationService(apiHost: config.API_HOST_NAME, userSession: userSession),
            networkService: RealNetworkService(apiHost: config.API_HOST_NAME, http: .init(userSession: userSession))
        )
    }

    static func dev() -> DependencyContainer {
        let config = AppConfig.fromInfoPList()
        let tokenProvider = KeychainTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        return DependencyContainer(
            appConfig: config,
            userSession: userSession,
            tokenProvider: tokenProvider,
            authenticationService: RealAuthenticationService(apiHost: config.API_HOST_NAME, userSession: userSession),
            networkService: RealNetworkService(apiHost: config.API_HOST_NAME, http: .init(userSession: userSession))
        )
    }
    
    static func stub() -> DependencyContainer {
        let tokenProvider = StubTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        return DependencyContainer(
            appConfig: .fromInfoPList(),
            userSession: userSession,
            tokenProvider: tokenProvider,
            authenticationService: StubAuthenticationService(userSession: userSession),
            networkService: StubNetworkService()
        )
    }
}
