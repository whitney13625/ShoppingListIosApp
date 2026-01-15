
import Observation

@Observable
class AppState {
    
    private var isInitialLoading = true
    
    let dependencies: DependencyContainer
    private var authenticationService: AuthenticationService
    private var networkService: NetworkService
    private var authState: AuthState
    
    
    init(dependencies: DependencyContainer = .stub()) {
        self.dependencies = dependencies
        self.authenticationService = dependencies.authenticationService
        self.networkService = dependencies.networkService
        self.authState = dependencies.authState
    }
    
    var currentFlow: AppFlow {
        if isInitialLoading { return .splash }
        return dependencies.authState.isAuthenticated ? .main : .authentication
    }

    @MainActor
    func bootstrap() async {
        await dependencies.authState.status.load { await dependencies.authenticationService.checkSession() }
        isInitialLoading = false
    }
}

enum AppFlow {
    case splash, authentication, main
}

extension AppState {
    static let stub = AppState(dependencies: DependencyContainer.stub())
    static let live = AppState(dependencies: DependencyContainer.live())
}
