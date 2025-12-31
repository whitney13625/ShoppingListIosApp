
import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknownError
    case noData
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

class Http {
    // For requests with a body (POST, PUT)
    func performRequest<T: Codable, U: Codable>(
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
    func performRequest<U: Codable>(
        _ url: URL,
        method: HTTPMethod
    ) async throws -> U {
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await executeRequest(request)
    }

    func executeRequest<U: Codable>(_ request: URLRequest) async throws -> U {
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
