import Foundation

protocol NetworkService {
    func fetchShoppingItems() async throws -> [ShoppingItemDTO]
    func getShoppingItem(_ id: String) async throws -> ShoppingItemDTO
    @discardableResult
    func addShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO
    @discardableResult
    func updateShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO
    func deleteShoppingItem(_ id: String) async throws
    func fetchCategories() async throws -> [CategoryDTO]
    func getCategory(_ id: String) async throws -> CategoryDTO
    @discardableResult
    func addCategory(_ category: CategoryDTO) async throws -> CategoryDTO
    @discardableResult
    func updateCategory(_ category: CategoryDTO) async throws -> CategoryDTO
    func deleteCategory(_ id: String) async throws
}

enum NetworkApiError: Error {
    case shoppingItemNotFound
    case categoryNotFound
}
