
import SwiftUI

struct BootstrapView: View {
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        switch appState.currentFlow {
        case .splash:
            ProgressView("Splash...")
        case .authentication:
            LoginView(viewModel: appState.loginViewModel)
        case .main:
            ShoppingListView(viewModel: appState.shoppingListViewModel)
        }
    }
}
