
import Observation

@Observable
class AppState {
    
    private var isInitialLoading = true
    
    let dependencies: DependencyContainer
    private var authenticationService: AuthenticationService
    private var networkService: NetworkService
    private var userSession: UserSession
    
    
    init(dependencies: DependencyContainer = .live()) {
        self.dependencies = dependencies
        self.authenticationService = dependencies.authenticationService
        self.networkService = dependencies.networkService
        self.userSession = dependencies.userSession
    }
    
    var currentFlow: AppFlow {
        if isInitialLoading { return .splash }
        return dependencies.userSession.isAuthenticated ? .main : .authentication
    }

    @MainActor
    func bootstrap() async {
        await dependencies.authenticationService.checkSession()
        isInitialLoading = false
    }
}

enum AppFlow {
    case splash, authentication, main
}

extension AppState {
    static let stub = AppState(dependencies: DependencyContainer.stub())
    static let preview = AppState(dependencies: DependencyContainer.stub())
    static let dev = AppState(dependencies: DependencyContainer.dev())
    static let live = AppState(dependencies: DependencyContainer.live())
}
