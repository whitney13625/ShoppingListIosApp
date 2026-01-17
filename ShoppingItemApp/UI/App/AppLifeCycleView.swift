
import SwiftUI

struct AppLifeCycleView<Content: View>: View {
    
    var content: () -> Content
    var onAppBecomeActive: () -> Void
    var onAppBecomeInActive: () -> Void
    
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        content()
            .onChange(of: scenePhase) { old, new in
                if old == .inactive && new == .active {
                    onAppBecomeActive()
                }
                else if old == .active && new == .inactive {
                    onAppBecomeInActive()
                }
            }
    }
}
