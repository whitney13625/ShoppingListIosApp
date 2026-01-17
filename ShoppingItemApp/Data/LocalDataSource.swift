import Foundation

// With LocalDataSorce protocol, we can refactor the database to a different stack

protocol LocalDataSource {
    
    // Importer
    func performBatchImport(action: @escaping (ShoppingItemImporter) throws -> Void) async throws
    func performImport(action: @escaping (ShoppingItemImporter) throws -> Void) async throws
    
    // Shopping Items
    func getShoppingItems() async throws -> [ShoppingItem]
    func getShoppingItem(id: String) async throws -> ShoppingItem
    func saveShoppingItems(_ items: [ShoppingItem]) async throws
    func addShoppingItem(_ item: ShoppingItem) async throws
    func updateShoppingItem(_ item: ShoppingItem) async throws
    func deleteShoppingItem(id: String) async throws
    func deleteAllShoppingItems() async throws

    // Categories
    func getCategories() async throws -> [Category]
    func getCategory(id: String) async throws -> Category
    func saveCategories(_ categories: [Category]) async throws
    func addCategory(_ category: Category) async throws
    func updateCategory(_ category: Category) async throws
    func deleteCategory(id: String) async throws
    func deleteAllCategories() async throws
}
