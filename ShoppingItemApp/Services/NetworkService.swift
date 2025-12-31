import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknownError
    case noData
}

enum Endpoint {
    case fetchItems
    case addItem
    case updateItem(UUID)
    case deleteItem(UUID)
    
    case fetchCategories
    case addCategory
    case updateCategory(UUID)
    case deleteCategory(UUID)
    
    var path: String {
        switch self {
        case .fetchItems, .addItem:
            return "items"
        case .updateItem(let id), .deleteItem(let id):
            return "items/\(id.uuidString)"
        case .fetchCategories, .addCategory:
            return "categories"
        case .updateCategory(let id), .deleteCategory(let id):
            return "categories/\(id.uuidString)"
        }
    }
}

enum HTTPMethod {
    case GET
    case POST
    case PUT
    case DELETE
    
    var value: String {
        switch self {
        case .GET:
            "GET"
        case .POST:
            "POST"
        case .PUT:
            "PUT"
        case .DELETE:
            "DELETE"
        }
    }
}

class NetworkService {
    
    let appConfig: AppConfig = .init(API_HOST: "http://localhost:3000")

    private func uri(_ parts: String...) -> URL {
        URL(string: "https://\(appConfig.API_HOST)/api/" + parts.joined(separator: "/"))!
    }
    
    // MARK: - Shopping Items
    
    func fetchShoppingItems() async throws -> [ShoppingItem] {
        let url = uri("shopping")
        return try await performRequest(url, method: .GET)
    }
    
    func getShoppingItem(_ id: String) async throws -> ShoppingItem {
        let url = uri("shopping", id)
        return try await performRequest(url, method: .GET)
    }
    
    func addShoppingItem(_ item: ShoppingItem) async throws -> ShoppingItem {
        let url = uri("shopping")
        return try await performRequest(url, method: .POST, body: item)
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async throws -> ShoppingItem {
        let url = uri("shopping", item.id)
        return try await performRequest(url, method: .PUT, body: item)
    }
    
    func deleteShoppingItem(_ id: String) async throws {
        let url = uri("shopping", id)
        _ = try await performRequest(url, method: .DELETE) as EmptyResponse
    }
    
    // MARK: - Categories
    
    func fetchCategories() async throws -> [Category] {
        let url = uri("categories")
        return try await performRequest(url, method: .GET)
    }
    
    func getCategory(_ id: String) async throws -> Category {
        let url = uri("categories", id)
        return try await performRequest(url, method: .GET)
    }
    
    func addCategory(_ category: Category) async throws -> Category {
        let url = uri("categories")
        return try await performRequest(url, method: .POST, body: category)
    }
    
    func updateCategory(_ category: Category) async throws -> Category {
        let url = uri("categories", category.id)
        return try await performRequest(url, method: .PUT, body: category)
    }
    
    func deleteCategory(_ category: Category) async throws {
        let url = uri("categories", category.id)
        _ = try await performRequest(url, method: .DELETE) as EmptyResponse
    }

    // For requests with a body (POST, PUT)
    private func performRequest<T: Codable, U: Codable>(
        _ url: URL,
        method: HTTPMethod,
        body: T
    ) async throws -> U {
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        return try await executeRequest(request)
    }

    // For requests without a body (GET, DELETE)
    private func performRequest<U: Codable>(
        _ url: URL,
        method: HTTPMethod
    ) async throws -> U {
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await executeRequest(request)
    }

    private func executeRequest<U: Codable>(_ request: URLRequest) async throws -> U {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        if data.isEmpty {
            if U.self == EmptyResponse.self {
                return EmptyResponse() as! U
            } else {
                throw NetworkError.noData
            }
        }
        
        do {
            let decodedObject = try JSONDecoder().decode(U.self, from: data)
            return decodedObject
        } catch {
            throw NetworkError.decodingError
        }
    }
}

// Helper struct for DELETE requests where no response body is expected
struct EmptyResponse: Codable {}
