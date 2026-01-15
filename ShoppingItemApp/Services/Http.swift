
import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknownError
    case noData
    case responseError(message: String)
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
    
    private let userSession: UserSession
    
    init(userSession: UserSession) {
        self.userSession = userSession
    }
    
    // For requests with a body (POST, PUT)
    func performRequest<T: Codable, U: Codable>(
        _ url: URL,
        method: HTTPMethod,
        body: T,
        authRequired: Bool = true
    ) async throws -> U {
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        
        if authRequired, let token = userSession.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        return try await executeRequest(request)
    }

    // For requests without a body (GET, DELETE)
    func performRequest<U: Codable>(
        _ url: URL,
        method: HTTPMethod,
        authRequired: Bool = true
    ) async throws -> U {
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        
        if authRequired, let token = userSession.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await executeRequest(request)
    }

    func executeRequest<U: Codable>(_ request: URLRequest) async throws -> U {
        
        print("Sending request: \(request.url?.absoluteURL.absoluteString ?? "no url")")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        logJson(data: data, urlString: request.url?.absoluteURL.absoluteString ?? "no url")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard  (200...299).contains(httpResponse.statusCode) else {
            throw try handleError(data, httpResponse)
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
    
    private struct ApiErrorResponse: Codable {
        var error: String?
    }
    
    private let handleError: (Data, HTTPURLResponse?) throws -> Error = { data, response in
        guard let response else {
            return NetworkError.invalidResponse
        }
        if let message = try? JSONDecoder().decode(ApiErrorResponse.self, from: data).error {
            return NetworkError.responseError(message: message)
        }
        else {
            return NetworkError.invalidResponse
        }
    }
    
    private func logJson(data: Data, urlString: String) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("logJson: url = \(urlString), \n json \(json)")
        } catch {
            print("logJson: Error serializing json: \(error.localizedDescription)")
        }
    }
}

// Helper struct for DELETE requests where no response body is expected
struct EmptyResponse: Codable {}
