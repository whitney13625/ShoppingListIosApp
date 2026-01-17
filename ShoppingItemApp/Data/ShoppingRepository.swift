
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
