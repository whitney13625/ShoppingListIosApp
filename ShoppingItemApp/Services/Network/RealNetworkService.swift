
import Foundation

class RealNetworkService: NetworkService {
    
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
