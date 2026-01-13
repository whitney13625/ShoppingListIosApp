import Foundation

protocol NetworkService {
    func fetchShoppingItems() async throws -> [ShoppingItem]
    func getShoppingItem(_ id: String) async throws -> ShoppingItem
    @discardableResult
    func addShoppingItem(_ item: ShoppingItem) async throws -> ShoppingItem
    @discardableResult
    func updateShoppingItem(_ item: ShoppingItem) async throws -> ShoppingItem
    func deleteShoppingItem(_ id: String) async throws
    func fetchCategories() async throws -> [Category]
    func getCategory(_ id: String) async throws -> Category
    @discardableResult
    func addCategory(_ category: Category) async throws -> Category
    @discardableResult
    func updateCategory(_ category: Category) async throws -> Category
    func deleteCategory(_ id: String) async throws
}

enum NetworkApiError: Error {
    case shoppingItemNotFound
    case categoryNotFound
}
