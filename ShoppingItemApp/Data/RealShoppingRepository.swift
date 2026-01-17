
import Foundation

class RealShoppingRepository: ShoppingRepository {
    
    private let localDataSource: LocalDataSource

    init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
    }

    func getShoppingItems() async throws -> [ShoppingItem] {
        try await localDataSource.getShoppingItems()
    }

    func getShoppingItem(id: String) async throws -> ShoppingItem {
        try await localDataSource.getShoppingItem(id: id)
    }

    func addShoppingItem(_ item: ShoppingItem) async throws {
        _ = try await localDataSource.addShoppingItem(item)
    }

    func updateShoppingItem(_ item: ShoppingItem) async throws {
        _ = try await localDataSource.updateShoppingItem(item)
    }

    func deleteShoppingItem(id: String) async throws {
        try await localDataSource.deleteShoppingItem(id: id)
    }

    func getCategories() async throws -> [Category] {
        try await localDataSource.getCategories()
    }

    func getCategory(id: String) async throws -> Category {
        try await localDataSource.getCategory(id: id)
    }

    func addCategory(_ category: Category) async throws {
        _ = try await localDataSource.addCategory(category)
    }

    func updateCategory(_ category: Category) async throws {
        _ = try await localDataSource.updateCategory(category)
    }

    func deleteCategory(id: String) async throws {
        try await localDataSource.deleteCategory(id: id)
    }
}
