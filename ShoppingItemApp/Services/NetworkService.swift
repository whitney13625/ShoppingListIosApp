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

class StubNetworkService: NetworkService {
    
    private let fruitCategory = Category(id: UUID().uuidString, name: "Fruits")
    
    private var categories: [Category]
    private var shoppingItems: [ShoppingItem]
    
    init() {
        let fruitCategory = Category(id: UUID().uuidString, name: "Fruits")
        
        self.categories = [
            fruitCategory,
            Category(id: UUID().uuidString, name: "Vegetables"),
            Category(id: UUID().uuidString, name: "Dairy"),
            Category(id: UUID().uuidString, name: "Meat")
        ]
        
        self.shoppingItems = [
            ShoppingItem(id: UUID().uuidString, name: "Apple", quantity: 2, category: fruitCategory),
            ShoppingItem(id: UUID().uuidString, name: "Banana", quantity: 3, category: fruitCategory),
            ShoppingItem(id: UUID().uuidString, name: "Orange", quantity: 1, category: fruitCategory)
        ]
    }
    
    func fetchShoppingItems() async throws -> [ShoppingItem] {
        try await Task.sleep(for: .seconds(3))
        let mockCategory = Category(id: UUID().uuidString, name: "Fruits")
        return shoppingItems
    }
    
    func getShoppingItem(_ id: String) async throws -> ShoppingItem {
        guard let item = shoppingItems.first(where: { $0.id == id }) else {
            throw NetworkApiError.shoppingItemNotFound
        }
        return item
    }
    
    func addShoppingItem(_ item: ShoppingItem) async throws -> ShoppingItem {
        try await Task.sleep(for: .seconds(3))
        shoppingItems.append(item)
        return item
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async throws -> ShoppingItem {
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

class ConnectToServerNetworkService: NetworkService {
    
    let appConfig: AppConfig = .init(API_HOST: "http://localhost:3000")
    private let http: Http = .init()

    private func uri(_ parts: String...) -> URL {
        URL(string: "https://\(appConfig.API_HOST)/api/" + parts.joined(separator: "/"))!
    }
    
    // MARK: - Shopping Items
    
    func fetchShoppingItems() async throws -> [ShoppingItem] {
        let url = uri("shopping")
        return try await http.performRequest(url, method: .GET)
    }
    
    func getShoppingItem(_ id: String) async throws -> ShoppingItem {
        let url = uri("shopping", id)
        return try await http.performRequest(url, method: .GET)
    }
    
    func addShoppingItem(_ item: ShoppingItem) async throws -> ShoppingItem {
        let url = uri("shopping")
        return try await http.performRequest(url, method: .POST, body: item)
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async throws -> ShoppingItem {
        let url = uri("shopping", item.id)
        return try await http.performRequest(url, method: .PUT, body: item)
    }
    
    func deleteShoppingItem(_ id: String) async throws {
        let url = uri("shopping", id)
        _ = try await http.performRequest(url, method: .DELETE) as EmptyResponse
    }
    
    // MARK: - Categories
    
    func fetchCategories() async throws -> [Category] {
        let url = uri("categories")
        return try await http.performRequest(url, method: .GET)
    }
    
    func getCategory(_ id: String) async throws -> Category {
        let url = uri("categories", id)
        return try await http.performRequest(url, method: .GET)
    }
    
    func addCategory(_ category: Category) async throws -> Category {
        let url = uri("categories")
        return try await http.performRequest(url, method: .POST, body: category)
    }
    
    func updateCategory(_ category: Category) async throws -> Category {
        let url = uri("categories", category.id)
        return try await http.performRequest(url, method: .PUT, body: category)
    }
    
    func deleteCategory(_ id: String) async throws {
        let url = uri("categories", id)
        _ = try await http.performRequest(url, method: .DELETE) as EmptyResponse
    }

}

enum NetworkApiError: Error {
    case shoppingItemNotFound
    case categoryNotFound
}
