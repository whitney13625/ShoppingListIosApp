
import Foundation

class StubNetworkService: NetworkService {
    
    private let fruitCategory = CategoryApiModel(id: UUID().uuidString, name: "Fruits")
    
    private var categories: Set<CategoryApiModel>
    private var shoppingItems: Set<ShoppingItemApiModel>
    
    init() {
        let fruitCategory = CategoryApiModel(id: UUID().uuidString, name: "Fruits")
        
        self.categories = [
            fruitCategory,
            CategoryApiModel(id: UUID().uuidString, name: "Vegetables"),
            CategoryApiModel(id: UUID().uuidString, name: "Dairy"),
            CategoryApiModel(id: UUID().uuidString, name: "Meat")
        ]
        
        self.shoppingItems = [
            ShoppingItemApiModel(id: UUID().uuidString, name: "Apple", quantity: 2, category: fruitCategory),
            ShoppingItemApiModel(id: UUID().uuidString, name: "Banana", quantity: 3, category: fruitCategory),
            ShoppingItemApiModel(id: UUID().uuidString, name: "Orange", quantity: 1, category: fruitCategory)
        ]
    }
    
    func fetchShoppingItems() async throws -> [ShoppingItemApiModel] {
        try await Task.sleep(for: .seconds(3))
        return Array(shoppingItems)
    }
    
    func getShoppingItem(_ id: String) async throws -> ShoppingItemApiModel {
        guard let item = shoppingItems.first(where: { $0.id == id }) else {
            throw NetworkApiError.shoppingItemNotFound
        }
        return item
    }
    
    func addShoppingItem(_ item: ShoppingItemApiModel) async throws -> ShoppingItemApiModel {
        try await Task.sleep(for: .seconds(3))
        shoppingItems.insert(item)
        return item
    }
    
    func updateShoppingItem(_ item: ShoppingItemApiModel) async throws -> ShoppingItemApiModel {
        try await Task.sleep(for: .seconds(3))
        shoppingItems.insert(item)
        return item
    }
    
    func deleteShoppingItem(_ id: String) async throws {
        try await Task.sleep(for: .seconds(3))
        if let item = Array(shoppingItems.filter{ $0.id == id }).first {
            shoppingItems.remove(item)
        }
    }
    
    func fetchCategories() async throws -> [CategoryApiModel] {
        try await Task.sleep(for: .seconds(3))
        return Array(categories)
    }
    
    func getCategory(_ id: String) async throws -> CategoryApiModel {
        try await Task.sleep(for: .seconds(3))
        guard let cat = categories.first(where: { $0.id == id }) else {
            throw NetworkApiError.categoryNotFound
        }
        return cat
    }
    
    func addCategory(_ category: CategoryApiModel) async throws -> CategoryApiModel {
        try await Task.sleep(for: .seconds(3))
        categories.insert(category)
        return category
    }
    
    func updateCategory(_ category: CategoryApiModel) async throws -> CategoryApiModel {
        try await Task.sleep(for: .seconds(3))
        categories.insert(category)
        return category
    }
    
    func deleteCategory(_ id: String) async throws {
        try await Task.sleep(for: .seconds(3))
        if let cat = Array(categories.filter{ $0.id == id }).first {
            categories.remove(cat)
        }
    }
}
