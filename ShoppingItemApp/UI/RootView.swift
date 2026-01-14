
import SwiftUI

struct RootView: View {
    
    @Environment(AppState.self) private var appState

    var body: some View {
        switch appState.currentFlow {
        case .splash:
            ProgressView("Splash...")
        case .authentication:
            LoginView(appState: appState)
        case .main:
            ShoppingListView(appState: appState)
        case .loading:
            ProgressView("Loading...")
        }
    }
}

#Preview {
    RootView()
}
