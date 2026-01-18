
import Observation

@Observable
@MainActor
class AppState {
    
    private var isInitialLoading = true
    
    let dependencies: DependencyContainer
    private var authenticationService: AuthenticationService
    private var shoppingRepository: ShoppingRepository
    private var userSession: UserSession
    
    var loginViewModel: LoginViewModel
    var shoppingListViewModel: ShoppingListViewModel
    
    init(dependencies: DependencyContainer = .live()) {
        self.dependencies = dependencies
        self.authenticationService = dependencies.authenticationService
        self.shoppingRepository = dependencies.shoppingRepository
        self.userSession = dependencies.userSession
        self.shoppingListViewModel = dependencies.makeShoppingListViewModel()
        self.loginViewModel = dependencies.makeLoginViewModel()
    }
    
    var currentFlow: AppFlow {
        if isInitialLoading { return .splash }
        return dependencies.userSession.isAuthenticated ? .main : .authentication
    }

    @MainActor
    func bootstrap() async {
        userSession.restoreSession()
        isInitialLoading = false
    }
    
    @MainActor
    func onEnterForeground() async {
        
    }
    
    @MainActor
    func onEnterBackground() async {
        
    }
}

enum AppFlow {
    case splash, authentication, main
}

extension AppState {
    static let stub = AppState(dependencies: DependencyContainer.stub())
    static let preview = AppState(dependencies: DependencyContainer.stub())
    static let live = AppState(dependencies: DependencyContainer.live())
}

fileprivate extension DependencyContainer {
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            userSession: userSession,
            authenticationService: authenticationService
        )
    }
    
    @MainActor
    func makeShoppingListViewModel() -> ShoppingListViewModel {
        ShoppingListViewModel(
            dataSyncService: dataSyncService,
            networkService: networkService,
            shoppingRepository: shoppingRepository
        )
    }
}
