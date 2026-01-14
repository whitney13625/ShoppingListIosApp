
import SwiftUI
import Observation

@Observable
class AuthState {    
    var status: Loading<Bool> = .notLoaded
    var isAuthenticated: Bool {
        self.status.loadedValue ?? false
    }
}
