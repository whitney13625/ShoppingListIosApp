
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
        let userIdStorage = UserDefaultsUserIdStorage()
        let userSession = RealUserSession(tokenProvider: tokenProvider, userIdStorage: userIdStorage)
        let coreDataStack = CoreDataStack(storeType: .onDisk)
        let http = Http(userSession: userSession)
        let authService = RealAuthenticationService(apiHost: config.API_HOST_NAME, http: http)
        let networkService = RealNetworkService(apiHost: config.API_HOST_NAME, http: http)
        let localDataSource = CoreDataDataSource(coreDataStack: coreDataStack)
        let shoppingRepository = RealShoppingRepository(localDataSource: localDataSource)
        let dataSyncService = RemoteToLocalSyncService(networkService: networkService, localDataSource: localDataSource)
        
        return DependencyContainer(
            appConfig: config,
            userSession: userSession,
            tokenProvider: tokenProvider,
            dataSyncService: dataSyncService,
            authenticationService: authService,
            networkService: networkService,
            shoppingRepository: shoppingRepository
        )
    }
    
    static func stub() -> DependencyContainer {
        let tokenProvider = StubTokenManager()
        let userIdStorage = StubUserIdStorage()
        let userSession = RealUserSession(tokenProvider: tokenProvider, userIdStorage: userIdStorage)
        let coreDataStack = CoreDataStack(storeType: .inMemory)
        let authService = StubAuthenticationService()
        let networkService = StubNetworkService()
        let localDataSource = CoreDataDataSource(coreDataStack: coreDataStack)
        let shoppingRepository = RealShoppingRepository(localDataSource: localDataSource)
        let dataSyncService = RemoteToLocalSyncService(networkService: networkService, localDataSource: localDataSource)
        
        return DependencyContainer(
            appConfig: .fromInfoPList(),
            userSession: userSession,
            tokenProvider: tokenProvider,
            dataSyncService: dataSyncService,
            authenticationService: authService,
            networkService: networkService,
            shoppingRepository: shoppingRepository
        )
    }
}

extension DependencyContainer {
    func resolve<T>(_ keyPath: KeyPath<DependencyContainer, T>) -> T {
        return self[keyPath: keyPath]
    }
}
