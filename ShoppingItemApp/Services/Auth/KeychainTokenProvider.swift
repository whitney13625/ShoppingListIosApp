
import Foundation

class KeychainTokenManager: TokenProvider {
    
    private let service = KeychainCredentialStoreService()
    
    func getToken(userId: String) throws -> String? {
        guard let c: TokenCredential = try service.find(id: userId) else {
            return nil
        }
        return c.token
    }
    
    func saveToken(_ token: String, userId: String) throws {
        try service.store(TokenCredential(id: userId, token: token) )
    }
    
    func deleteToken(userId: String) throws {
        try service.remove(TokenCredential.self, id: userId)
    }
}

private struct TokenCredential: Credential {
    var id: String
    var token: String
}

protocol Credential: Codable {
    associatedtype ID: Hashable
    var id: ID { get }
}

private class KeychainCredentialStoreService {
    
    private func serviceName<T: Credential>(_: T.Type) -> String {
        "\(T.self)"
    }
    
    func store<T: Credential>(_ item: T) throws {
        
        let data = try JSONEncoder().encode(item)
        let key = String(describing: item.id)
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService: serviceName(T.self),
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print("Error storing item: \(status)")
        }
    }
    
    func retrieve<T: Credential>(_ type: T.Type) throws -> Set<T> {
        let refQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName(T.self),
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnPersistentRef as String: true,
            kSecReturnAttributes as String: true
        ]
        
        var refResult: CFTypeRef?
        let refStatus = SecItemCopyMatching(refQuery as CFDictionary, &refResult)
        
        guard refStatus == errSecSuccess,
              let items = refResult as? [[String: Any]]
        else {
            return []
        }
        
        return items
            .compactMap { dict in
                guard let persistentRef = dict[kSecValuePersistentRef as String] as? Data else {
                    return nil
                }
            
                let dataQuery = [
                    kSecClass: kSecClassGenericPassword,
                    kSecValuePersistentRef: persistentRef,
                    kSecReturnData: true
                ] as CFDictionary
            
                var dataResult: CFTypeRef?
                let dataStatus = SecItemCopyMatching(dataQuery as CFDictionary, &dataResult)
            
                guard dataStatus == errSecSuccess,
                      let data = dataResult as? Data
                else {
                    return nil
                }
            
                return try? JSONDecoder().decode(T.self, from: data)
            }
            .set
    }
    
    func find<T: Credential>(id: String) throws -> T? {
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService: serviceName(T.self),
            kSecAttrAccount: id,
            kSecReturnData: true
        ] as CFDictionary
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data
        else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func remove<T: Credential>(_ type: T.Type, id: String) throws {
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService: serviceName(T.self),
            kSecAttrAccount: id,
        ] as CFDictionary
        SecItemDelete(query)
    }
}

