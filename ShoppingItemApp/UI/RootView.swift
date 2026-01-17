
import SwiftUI

struct RootView: View {
    
    @Environment(AppState.self) private var appState

    var body: some View {
        AppLifeCycleView {
            BootstrapView()
        } onAppBecomeActive: {
            Task { @MainActor in
                await appState.onEnterForeground()
            }
        } onAppBecomeInActive: {
            Task { @MainActor in
                await appState.onEnterBackground()
            }
        }
    }
}



#Preview {
    RootView()
}
