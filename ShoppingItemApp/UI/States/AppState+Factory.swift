
extension AppState {
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            authState: self.dependencies.authState,
            authenticationService: self.dependencies.authenticationService
        )
    }
    
    @MainActor
    func makeShoppingListViewModel() -> ShoppingListViewModel {
        ShoppingListViewModel(networkService: self.dependencies.networkService)
    }
}
