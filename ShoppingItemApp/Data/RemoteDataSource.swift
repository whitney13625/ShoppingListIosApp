import Foundation

protocol RemoteDataSource {
    func fetchShoppingItems() async throws -> [ShoppingItemDTO]
    func getShoppingItem(_ id: String) async throws -> ShoppingItemDTO
    func addShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO
    func updateShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO
    func deleteShoppingItem(_ id: String) async throws

    func fetchCategories() async throws -> [CategoryDTO]
    func getCategory(_ id: String) async throws -> CategoryDTO
    func addCategory(_ category: CategoryDTO) async throws -> CategoryDTO
    func updateCategory(_ category: CategoryDTO) async throws -> CategoryDTO
    func deleteCategory(_ id: String) async throws
}

class RemoteDataSourceImpl: RemoteDataSource {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchShoppingItems() async throws -> [ShoppingItemDTO] {
        try await networkService.fetchShoppingItems()
    }

    func getShoppingItem(_ id: String) async throws -> ShoppingItemDTO {
        try await networkService.getShoppingItem(id)
    }

    func addShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO {
        try await networkService.addShoppingItem(item)
    }

    func updateShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO {
        try await networkService.updateShoppingItem(item)
    }

    func deleteShoppingItem(_ id: String) async throws {
        try await networkService.deleteShoppingItem(id)
    }

    func fetchCategories() async throws -> [CategoryDTO] {
        try await networkService.fetchCategories()
    }

    func getCategory(_ id: String) async throws -> CategoryDTO {
        try await networkService.getCategory(id)
    }

    func addCategory(_ category: CategoryDTO) async throws -> CategoryDTO {
        try await networkService.addCategory(category)
    }

    func updateCategory(_ category: CategoryDTO) async throws -> CategoryDTO {
        try await networkService.updateCategory(category)
    }

    func deleteCategory(_ id: String) async throws {
        try await networkService.deleteCategory(id)
    }
}
