
import Observation

protocol LoadableViewModelProtocol: AnyObject {
    
    func performLoad<T>(
        on keyPath: ReferenceWritableKeyPath<Self, Loading<T>>,
        operation: @escaping () async throws -> T
    ) async
    
    func performLoad<T>(
        showLoading: Bool,
        on keyPath: ReferenceWritableKeyPath<Self, Loading<T>>,
        operation: @escaping () async throws -> T
    ) async
}

extension LoadableViewModelProtocol where Self: Observable {
    // Generic Helper Function, using KeyPath to assign which Loading variable
    
    func performLoad<T>(
        on keyPath: ReferenceWritableKeyPath<Self, Loading<T>>,
        operation: @escaping () async throws -> T
    ) async {
        await performLoad(showLoading: true, on: keyPath, operation: operation)
    }
    
    func performLoad<T>(
        showLoading: Bool,
        on keyPath: ReferenceWritableKeyPath<Self, Loading<T>>,
        operation: @escaping () async throws -> T
    ) async {
        await MainActor.run {
            if showLoading {
                self[keyPath: keyPath] = .loading
            }
        }
        do {
            let result = try await operation()
            self[keyPath: keyPath] = .loaded(result)
        } catch {
            self[keyPath: keyPath] = .error(error)
        }
    }
}

