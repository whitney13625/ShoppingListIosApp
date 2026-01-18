
import Testing
@testable import ShoppingItemApp

class MockDataSyncService: DataSyncService {
    
    var calledCount = 0
    
    func sync() async throws {
        calledCount += 1
    }
}
