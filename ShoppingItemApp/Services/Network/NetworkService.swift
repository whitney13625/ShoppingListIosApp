import Foundation

protocol NetworkService {
    func fetchShoppingItems() async throws -> [ShoppingItemApiModel]
    func getShoppingItem(_ id: String) async throws -> ShoppingItemApiModel
    @discardableResult
    func addShoppingItem(_ item: ShoppingItemApiModel) async throws -> ShoppingItemApiModel
    @discardableResult
    func updateShoppingItem(_ item: ShoppingItemApiModel) async throws -> ShoppingItemApiModel
    func deleteShoppingItem(_ id: String) async throws
    func fetchCategories() async throws -> [CategoryApiModel]
    func getCategory(_ id: String) async throws -> CategoryApiModel
    @discardableResult
    func addCategory(_ category: CategoryApiModel) async throws -> CategoryApiModel
    @discardableResult
    func updateCategory(_ category: CategoryApiModel) async throws -> CategoryApiModel
    func deleteCategory(_ id: String) async throws
}

enum NetworkApiError: Error {
    case notAuthencated
    case shoppingItemNotFound
    case categoryNotFound
}
