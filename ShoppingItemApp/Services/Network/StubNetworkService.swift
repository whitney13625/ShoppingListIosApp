
import Foundation

class StubNetworkService: NetworkService {
    
    private let fruitCategory = Category(id: UUID().uuidString, name: "Fruits")
    
    private var categories: [Category]
    private var shoppingItems: [ShoppingItemDTO]
    
    init() {
        let fruitCategory = Category(id: UUID().uuidString, name: "Fruits")
        
        self.categories = [
            fruitCategory,
            Category(id: UUID().uuidString, name: "Vegetables"),
            Category(id: UUID().uuidString, name: "Dairy"),
            Category(id: UUID().uuidString, name: "Meat")
        ]
        
        self.shoppingItems = [
            ShoppingItemDTO(id: UUID().uuidString, name: "Apple", quantity: 2, category: fruitCategory),
            ShoppingItemDTO(id: UUID().uuidString, name: "Banana", quantity: 3, category: fruitCategory),
            ShoppingItemDTO(id: UUID().uuidString, name: "Orange", quantity: 1, category: fruitCategory)
        ]
    }
    
    func fetchShoppingItems() async throws -> [ShoppingItemDTO] {
        try await Task.sleep(for: .seconds(3))
        let mockCategory = Category(id: UUID().uuidString, name: "Fruits")
        return shoppingItems
    }
    
    func getShoppingItem(_ id: String) async throws -> ShoppingItemDTO {
        guard let item = shoppingItems.first(where: { $0.id == id }) else {
            throw NetworkApiError.shoppingItemNotFound
        }
        return item
    }
    
    func addShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO {
        try await Task.sleep(for: .seconds(3))
        shoppingItems.append(item)
        return item
    }
    
    func updateShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO {
        try await Task.sleep(for: .seconds(3))
        guard let index = shoppingItems.firstIndex(where: { $0.id == item.id }) else {
            throw NetworkApiError.shoppingItemNotFound
        }
        shoppingItems[index] = item
        return item
    }
    
    func deleteShoppingItem(_ id: String) async throws {
        try await Task.sleep(for: .seconds(3))
        shoppingItems.removeAll(where: { $0.id == id })
    }
    
    func fetchCategories() async throws -> [Category] {
        try await Task.sleep(for: .seconds(3))
        return categories
    }
    
    func getCategory(_ id: String) async throws -> Category {
        try await Task.sleep(for: .seconds(3))
        guard let cat = categories.first(where: { $0.id == id }) else {
            throw NetworkApiError.categoryNotFound
        }
        return cat
    }
    
    func addCategory(_ category: Category) async throws -> Category {
        try await Task.sleep(for: .seconds(3))
        categories.append(category)
        return category
    }
    
    func updateCategory(_ category: Category) async throws -> Category {
        try await Task.sleep(for: .seconds(3))
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else {
            throw NetworkApiError.categoryNotFound
        }
        categories[index] = category
        return category
    }
    
    func deleteCategory(_ id: String) async throws {
        try await Task.sleep(for: .seconds(3))
        categories.removeAll(where: { $0.id == id })
    }
}
