
import Foundation

indirect enum Loading<T> {
    case notLoaded
    case loading
    case reloading(Loading<T>)
    case loaded(T)
    case error(Error)
}

extension Loading {
    mutating func startLoading() {
        switch self {
        case .notLoaded:
            self = .loading
        default:
            self = .reloading(self)
        }
    }
    
    mutating func load(_ fn: () async throws -> T) async {
        do {
            self = .loaded(try await fn())
        }
        catch {
            self = .error(error)
        }
    }
    
    var loadedValue: T? {
        switch self {
        case .loaded(let value): value
        case .reloading(let r): r.loadedValue
        default: nil
        }
    }
    
    var isNotLoaded: Bool {
        switch self {
        case .notLoaded: true
        default: false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading, .reloading(_): true
        default: false
        }
    }
    
    var isFailed: Bool {
        switch self {
        case .error(_): true
        default: false
        }
    }
    
    static func from(_ fn: () async throws -> T) async -> Self {
        do {
            return .loaded(try await fn())
        }
        catch {
            return .error(error)
        }
    }
}

extension Loading: Equatable where T: Equatable {
    static func == (lhs: Loading<T>, rhs: Loading<T>) -> Bool {
        lhs.loadedValue == rhs.loadedValue
    }
}
