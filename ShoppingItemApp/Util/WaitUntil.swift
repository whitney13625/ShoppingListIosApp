import Foundation

private func pollUntil<T>(
    pollingInterval: TimeInterval,
    deadline: Date,
    _ operation: @escaping () async throws -> T,
    continuePolling: @escaping (T) -> Bool
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            while Date.now < deadline {
                try Task.checkCancellation()
                let result = try await operation()
                if !continuePolling(result) {
                    return result
                }
                try await Task.sleep(for: .seconds(pollingInterval))
            }
            throw GeneralError.operationTimeout
        }
        return try await group.next()!
    }
}

func waitUntil(
    pollingInterval: TimeInterval = 0.5,
    timeout: TimeInterval = 30,
    _ condition: @escaping () async throws -> Bool
) async throws {
    let deadline: Date = timeout == .infinity ? .distantFuture : .now.addingTimeInterval(timeout)
    _ = try await pollUntil(
        pollingInterval: pollingInterval,
        deadline: deadline,
        condition,
        continuePolling: { !$0 }
    )
}

func waitUntil<T>(
    pollingInterval: TimeInterval = 0.5,
    timeout: TimeInterval = 30,
    _ fetch: @escaping () async throws -> T?
) async throws -> T {
    let deadline: Date = timeout == .infinity ? .distantFuture : .now.addingTimeInterval(timeout)
    return try await pollUntil(
        pollingInterval: pollingInterval,
        deadline: deadline,
        fetch,
        continuePolling: { $0 == nil })!
}

func waitUntil(
    pollingInterval: TimeInterval = 0.5,
    timeout: TimeInterval = 30,
    onTimeout: @escaping () async throws -> Void,
    _ condition: @escaping () async throws -> Bool
) async throws {
    let deadline: Date = timeout == .infinity ? .distantFuture : .now.addingTimeInterval(timeout)
    
    do {
        _ = try await pollUntil(
            pollingInterval: pollingInterval,
            deadline: deadline,
            condition,
            continuePolling: { !$0 }
        )
    } catch let err {
        if (err as? GeneralError) == GeneralError.operationTimeout {
            do {
                try await onTimeout()
            } catch {
                throw error
            }
        }
        else {
            throw err
        }
    }
}

func waitUntil<T>(
    pollingInterval: TimeInterval = 0.5,
    timeout: TimeInterval = 30,
    onTimeout: @escaping () async throws -> T,
    _ fetch: @escaping () async throws -> T?
) async throws -> T {
    let deadline: Date = timeout == .infinity ? .distantFuture : .now.addingTimeInterval(timeout)
    do {
        return try await pollUntil(
            pollingInterval: pollingInterval,
            deadline: deadline,
            fetch,
            continuePolling: { $0 == nil })!
    }
    catch {
        do {
            return try await onTimeout()
        } catch {
            throw error
        }
    }
}
