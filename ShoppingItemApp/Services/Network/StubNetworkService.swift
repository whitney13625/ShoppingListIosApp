
import Foundation

class StubNetworkService: NetworkService {
    
    private let fruitCategory = CategoryDTO(id: UUID().uuidString, name: "Fruits")
    
    private var categories: Set<CategoryDTO>
    private var shoppingItems: Set<ShoppingItemDTO>
    
    init() {
        let fruitCategory = CategoryDTO(id: UUID().uuidString, name: "Fruits")
        
        self.categories = [
            fruitCategory,
            CategoryDTO(id: UUID().uuidString, name: "Vegetables"),
            CategoryDTO(id: UUID().uuidString, name: "Dairy"),
            CategoryDTO(id: UUID().uuidString, name: "Meat")
        ]
        
        self.shoppingItems = [
            ShoppingItemDTO(id: UUID().uuidString, name: "Apple", quantity: 2, category: fruitCategory),
            ShoppingItemDTO(id: UUID().uuidString, name: "Banana", quantity: 3, category: fruitCategory),
            ShoppingItemDTO(id: UUID().uuidString, name: "Orange", quantity: 1, category: fruitCategory)
        ]
    }
    
    func fetchShoppingItems() async throws -> [ShoppingItemDTO] {
        try await Task.sleep(for: .seconds(3))
        return Array(shoppingItems)
    }
    
    func getShoppingItem(_ id: String) async throws -> ShoppingItemDTO {
        guard let item = shoppingItems.first(where: { $0.id == id }) else {
            throw NetworkApiError.shoppingItemNotFound
        }
        return item
    }
    
    func addShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO {
        try await Task.sleep(for: .seconds(3))
        shoppingItems.insert(item)
        return item
    }
    
    func updateShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO {
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
    
    func fetchCategories() async throws -> [CategoryDTO] {
        try await Task.sleep(for: .seconds(3))
        return Array(categories)
    }
    
    func getCategory(_ id: String) async throws -> CategoryDTO {
        try await Task.sleep(for: .seconds(3))
        guard let cat = categories.first(where: { $0.id == id }) else {
            throw NetworkApiError.categoryNotFound
        }
        return cat
    }
    
    func addCategory(_ category: CategoryDTO) async throws -> CategoryDTO {
        try await Task.sleep(for: .seconds(3))
        categories.insert(category)
        return category
    }
    
    func updateCategory(_ category: CategoryDTO) async throws -> CategoryDTO {
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
