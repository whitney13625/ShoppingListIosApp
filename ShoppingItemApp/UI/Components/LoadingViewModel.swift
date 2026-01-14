
import Observation

protocol LoadableViewModelProtocol: AnyObject {
    func performLoad<T>(
        on keyPath: ReferenceWritableKeyPath<Self, Loading<T>>,
        operation: @escaping () async throws -> T
    )
}

extension LoadableViewModelProtocol where Self: Observable {
    // Generic Helper Function, using KeyPath to assign which Loading variable

    func performLoad<T>(
        on keyPath: ReferenceWritableKeyPath<Self, Loading<T>>,
        operation: @escaping () async throws -> T
    ) {
         self[keyPath: keyPath] = .loading

        Task {
            do {
                let result = try await operation()
                self[keyPath: keyPath] = .loaded(result)
            } catch {
                self[keyPath: keyPath] = .error(error)
            }
        }
    }

}

