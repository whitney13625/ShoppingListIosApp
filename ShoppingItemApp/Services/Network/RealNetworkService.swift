
import Foundation

class RealNetworkService: NetworkService {
    
    private let apiHost: String
    private let tokenProvider: TokenProvider
    private let http: Http = .init()
    
    init(apiHost: String, tokenProvider: TokenProvider) {
        self.apiHost = apiHost
        self.tokenProvider = tokenProvider
    }
    
    private func uri(_ parts: String...) -> URL {
        return URL(string: "http://\(apiHost)/api/" + parts.joined(separator: "/"))!
    }
    
    // MARK: - Shopping Items
    
    func fetchShoppingItems() async throws -> [ShoppingItemDTO] {
        let url = uri("shopping")
        return try await http.performRequest(url, method: .GET)
    }
    
    func getShoppingItem(_ id: String) async throws -> ShoppingItemDTO {
        let url = uri("shopping", id)
        return try await http.performRequest(url, method: .GET)
    }
    
    func addShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO {
        let url = uri("shopping")
        return try await http.performRequest(url, method: .POST, body: item)
    }
    
    func updateShoppingItem(_ item: ShoppingItemDTO) async throws -> ShoppingItemDTO {
        let url = uri("shopping", item.id)
        return try await http.performRequest(url, method: .PUT, body: item)
    }
    
    func deleteShoppingItem(_ id: String) async throws {
        let url = uri("shopping", id)
        _ = try await http.performRequest(url, method: .DELETE) as EmptyResponse
    }
    
    // MARK: - Categories
    
    func fetchCategories() async throws -> [CategoryDTO] {
        let url = uri("categories")
        return try await http.performRequest(url, method: .GET)
    }
    
    func getCategory(_ id: String) async throws -> CategoryDTO {
        let url = uri("categories", id)
        return try await http.performRequest(url, method: .GET)
    }
    
    func addCategory(_ category: CategoryDTO) async throws -> CategoryDTO {
        let url = uri("categories")
        return try await http.performRequest(url, method: .POST, body: category)
    }
    
    func updateCategory(_ category: CategoryDTO) async throws -> CategoryDTO {
        let url = uri("categories", category.id)
        return try await http.performRequest(url, method: .PUT, body: category)
    }
    
    func deleteCategory(_ id: String) async throws {
        let url = uri("categories", id)
        _ = try await http.performRequest(url, method: .DELETE) as EmptyResponse
    }

}
