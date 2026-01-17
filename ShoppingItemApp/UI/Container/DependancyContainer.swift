
struct DependencyContainer {
    
    let appConfig: AppConfig
    
    let userSession: UserSession
    let tokenProvider: TokenProvider
    let dataSyncService: DataSyncService
    
    let authenticationService: AuthenticationService
    let networkService: NetworkService
    let shoppingRepository: ShoppingRepository
    
    
    static func live() -> DependencyContainer {
        let config = AppConfig.fromInfoPList()
        let tokenProvider = KeychainTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        let coreDataStack = CoreDataStack(storeType: .onDisk)
        let networkService = RealNetworkService(apiHost: config.API_HOST_NAME, http: .init(userSession: userSession))
        let localDataSource = CoreDataDataSource(coreDataStack: coreDataStack)
        let dataSyncService = RemoteToLocalSyncService(networkService: networkService, localDataSource: localDataSource)
        
        return DependencyContainer(
            appConfig: config,
            userSession: userSession,
            tokenProvider: tokenProvider,
            dataSyncService: dataSyncService,
            authenticationService: RealAuthenticationService(apiHost: config.API_HOST_NAME, userSession: userSession),
            networkService: networkService,
            shoppingRepository: RealShoppingRepository(localDataSource: localDataSource)
        )
    }

    static func dev() -> DependencyContainer {
        let config = AppConfig.fromInfoPList()
        let tokenProvider = KeychainTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        let coreDataStack = CoreDataStack(storeType: .onDisk)
        let networkService = RealNetworkService(apiHost: config.API_HOST_NAME, http: .init(userSession: userSession))
        let localDataSource = CoreDataDataSource(coreDataStack: coreDataStack)
        let dataSyncService = RemoteToLocalSyncService(networkService: networkService, localDataSource: localDataSource)
        
        return DependencyContainer(
            appConfig: config,
            userSession: userSession,
            tokenProvider: tokenProvider,
            dataSyncService: dataSyncService,
            authenticationService: RealAuthenticationService(apiHost: config.API_HOST_NAME, userSession: userSession),
            networkService: networkService,
            shoppingRepository: RealShoppingRepository(localDataSource: localDataSource)
        )
    }
    
    static func stub() -> DependencyContainer {
        let tokenProvider = StubTokenManager()
        let userSession = RealUserSession(tokenProvider: tokenProvider)
        let coreDataStack = CoreDataStack(storeType: .inMemory)
        let networkService = StubNetworkService()
        let localDataSource = CoreDataDataSource(coreDataStack: coreDataStack)
        let dataSyncService = RemoteToLocalSyncService(networkService: networkService, localDataSource: localDataSource)
        
        return DependencyContainer(
            appConfig: .fromInfoPList(),
            userSession: userSession,
            tokenProvider: tokenProvider,
            dataSyncService: dataSyncService,
            authenticationService: StubAuthenticationService(userSession: userSession),
            networkService: networkService,
            shoppingRepository: RealShoppingRepository(localDataSource: localDataSource)
        )
    }
}

extension DependencyContainer {
    func resolve<T>(_ keyPath: KeyPath<DependencyContainer, T>) -> T {
        return self[keyPath: keyPath]
    }
}
