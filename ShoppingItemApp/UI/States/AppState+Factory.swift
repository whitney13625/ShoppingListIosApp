
extension AppState {
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            userSession: self.dependencies.userSession,
            authenticationService: self.dependencies.authenticationService
        )
    }
    
    @MainActor
    func makeShoppingListViewModel() -> ShoppingListViewModel {
        ShoppingListViewModel(networkService: self.dependencies.networkService)
    }
}
