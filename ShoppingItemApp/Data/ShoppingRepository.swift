import Foundation

// MARK: - Protocols

protocol ShoppingRepository {
    func getShoppingItems() async throws -> [ShoppingItem]
    func getShoppingItem(id: String) async throws -> ShoppingItem
    func addShoppingItem(_ item: ShoppingItem) async throws
    func updateShoppingItem(_ item: ShoppingItem) async throws
    func deleteShoppingItem(id: String) async throws

    func getCategories() async throws -> [Category]
    func getCategory(id: String) async throws -> Category
    func addCategory(_ category: Category) async throws
    func updateCategory(_ category: Category) async throws
    func deleteCategory(id: String) async throws
}





// MARK: - Implementation

class ShoppingRepositoryImpl: ShoppingRepository {
    private let remoteDataSource: RemoteDataSource
    private let localDataSource: LocalDataSource

    init(remoteDataSource: RemoteDataSource, localDataSource: LocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getShoppingItems() async throws -> [ShoppingItem] {
        // TODO: Implement offline logic
        let dtos = try await remoteDataSource.fetchShoppingItems()
        return dtos.map { ShoppingItem(from: $0) }
    }

    func getShoppingItem(id: String) async throws -> ShoppingItem {
        let dto = try await remoteDataSource.getShoppingItem(id)
        return ShoppingItem(from: dto)
    }

    func addShoppingItem(_ item: ShoppingItem) async throws {
        _ = try await remoteDataSource.addShoppingItem(item.toDTO())
    }

    func updateShoppingItem(_ item: ShoppingItem) async throws {
        _ = try await remoteDataSource.updateShoppingItem(item.toDTO())
    }

    func deleteShoppingItem(id: String) async throws {
        try await remoteDataSource.deleteShoppingItem(id)
    }

    func getCategories() async throws -> [Category] {
        // TODO: Implement offline logic
        let dtos = try await remoteDataSource.fetchCategories()
        return dtos.map { Category(from: $0) }
    }

    func getCategory(id: String) async throws -> Category {
        let dto = try await remoteDataSource.getCategory(id)
        return Category(from: dto)
    }

    func addCategory(_ category: Category) async throws {
        _ = try await remoteDataSource.addCategory(category.toDTO())
    }

    func updateCategory(_ category: Category) async throws {
        _ = try await remoteDataSource.updateCategory(category.toDTO())
    }

    func deleteCategory(id: String) async throws {
        try await remoteDataSource.deleteCategory(id)
    }
}
