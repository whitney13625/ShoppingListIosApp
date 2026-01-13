
import SwiftUI

extension View {
    func showError<E: Error>(for error: Binding<E?>, onDismiss: @escaping () -> Void = {}) -> some View {
        showError(for: error, onDismiss: onDismiss, additionalActions: { EmptyView() })
    }
    
    func showError<E: Error, V: View>(for error: Binding<E?>, onDismiss: @escaping () -> Void = {}, @ViewBuilder additionalActions: @escaping () -> V) -> some View {
        modifier(ShowErrorViewModifier(error: error, onDismiss: onDismiss, additionalActions: additionalActions))
    }
}

private struct ShowErrorViewModifier<E: Error, V: View>: ViewModifier {
    @Binding var error: E?
    
    var title: String? = nil
    var onDismiss: () -> Void
    var additionalActions: () -> V
    
    func body(content: Content) -> some View {
        content
            .alert(
                title ?? "Error",
                isPresented: .constant(error != nil),
                actions: {
                    Button(role: .cancel) {
                        onDismiss()
                        error = nil
                    } label: {
                        Text("OK")
                    }
                    additionalActions()
                },
                message: {
                    Text(error?.localizedDescription ?? "An unhandled error has occured")
                        .textCase(.none)
                }
            )
    }
}
