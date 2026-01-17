
struct DependencyContainer {
    
    let appConfig: AppConfig
    
    let userSession: UserSession
    let tokenProvider: TokenProvider
    let coreDataStack: CoreDataStack
    
    let authenticationService: AuthenticationService
    let shoppingRepository: ShoppingRepository
    
    static func live() -> DependencyContainer {
        let config = AppConfig.fromInfoPList()
        let tokenProvider = KeychainTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        let coreDataStack = CoreDataStack(storeType: .onDisk)
        let networkService = RealNetworkService(apiHost: config.API_HOST_NAME, http: .init(userSession: userSession))
        let remoteDataSource = RemoteDataSourceImpl(networkService: networkService)
        let localDataSource = CoreDataDataSource(coreDataStack: coreDataStack)
        
        return DependencyContainer(
            appConfig: config,
            userSession: userSession,
            tokenProvider: tokenProvider,
            coreDataStack: coreDataStack,
            authenticationService: RealAuthenticationService(apiHost: config.API_HOST_NAME, userSession: userSession),
            shoppingRepository: RealShoppingRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        )
    }

    static func dev() -> DependencyContainer {
        let config = AppConfig.fromInfoPList()
        let tokenProvider = KeychainTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        let coreDataStack = CoreDataStack(storeType: .onDisk)
        let networkService = RealNetworkService(apiHost: config.API_HOST_NAME, http: .init(userSession: userSession))
        let remoteDataSource = RemoteDataSourceImpl(networkService: networkService)
        let localDataSource = CoreDataDataSource(coreDataStack: coreDataStack)

        return DependencyContainer(
            appConfig: config,
            userSession: userSession,
            tokenProvider: tokenProvider,
            coreDataStack: coreDataStack,
            authenticationService: RealAuthenticationService(apiHost: config.API_HOST_NAME, userSession: userSession),
            shoppingRepository: RealShoppingRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        )
    }
    
    static func stub() -> DependencyContainer {
        let tokenProvider = StubTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        let coreDataStack = CoreDataStack(storeType: .inMemory)
        let networkService = StubNetworkService()
        let remoteDataSource = RemoteDataSourceImpl(networkService: networkService)
        let localDataSource = CoreDataDataSource(coreDataStack: coreDataStack)

        return DependencyContainer(
            appConfig: .fromInfoPList(),
            userSession: userSession,
            tokenProvider: tokenProvider,
            coreDataStack: coreDataStack,
            authenticationService: StubAuthenticationService(userSession: userSession),
            shoppingRepository: RealShoppingRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        )
    }
}
