
import Testing
@testable import ShoppingItemApp

class MockNetworkService: NetworkService {
    
    var calledCount = 0
    var errorToThrow: Error?
    
    var defaultShoppingItem: ShoppingItemApiModel?
    var defaultCategory: CategoryApiModel?
    
    private func incrementCalledAndThrowIfNeeded() throws {
        calledCount += 1
        if let errorToThrow {
            throw errorToThrow
        }
    }
    
    private func returnDefaultShoppingItemOrThrow() throws -> ShoppingItemApiModel {
        guard let defaultShoppingItem else {
            throw ShoppingListTestError.itemNotFound
        }
        return defaultShoppingItem
    }
    
    private func returnDefaultCategoryOrThrow() throws -> CategoryApiModel {
        guard let defaultCategory else {
            throw ShoppingListTestError.itemNotFound
        }
        return defaultCategory
    }
    
    func addPredefinedError() {
        self.errorToThrow = ShoppingListTestError.predefinedError
    }
    
    func fetchShoppingItems() async throws -> [ShoppingItemApiModel] {
        try incrementCalledAndThrowIfNeeded()
        return []
    }
    
    func getShoppingItem(_ id: String) async throws -> ShoppingItemApiModel {
        try incrementCalledAndThrowIfNeeded()
        return try returnDefaultShoppingItemOrThrow()
        
    }
    
    func addShoppingItem(_ item: ShoppingItemApiModel) async throws -> ShoppingItemApiModel {
        try incrementCalledAndThrowIfNeeded()
        return try returnDefaultShoppingItemOrThrow()
    }
    
    func updateShoppingItem(_ item: ShoppingItemApiModel) async throws -> ShoppingItemApiModel {
        try incrementCalledAndThrowIfNeeded()
        return item
    }
    
    func deleteShoppingItem(_ id: String) async throws {
        try incrementCalledAndThrowIfNeeded()
    }
    
    func fetchCategories() async throws -> [CategoryApiModel] {
        try incrementCalledAndThrowIfNeeded()
        return []
    }
    
    func getCategory(_ id: String) async throws -> CategoryApiModel {
        try incrementCalledAndThrowIfNeeded()
        return try returnDefaultCategoryOrThrow()
    }
    
    func addCategory(_ category: CategoryApiModel) async throws -> CategoryApiModel {
        try incrementCalledAndThrowIfNeeded()
        return category
    }
    
    func updateCategory(_ category: CategoryApiModel) async throws -> CategoryApiModel {
        try incrementCalledAndThrowIfNeeded()
        return category
    }
    
    func deleteCategory(_ id: String) async throws {
        try incrementCalledAndThrowIfNeeded()
    }
    
}


