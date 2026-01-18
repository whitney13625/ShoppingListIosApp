
import Testing
@testable import ShoppingItemApp

class MockShoppingRepository: ShoppingRepository {
    
    private var categories: Set<Category> = .init()
    private var shoppingItems: Set<ShoppingItem> = .init()
    
    var calledCount = 0
    var errorToThrow: Error?
    
    func initialise() {
        let fruitCategory = Category(id: "c1", name: "Fruits")
        self.categories = Set([
            fruitCategory,
            Category(id: "c2", name: "Vegetables"),
            Category(id: "c3", name: "Dairy"),
            Category(id: "c4", name: "Meat")
        ])
        
        self.shoppingItems = Set([
            ShoppingItem(id: "s1", name: "Apple", quantity: 2, category: fruitCategory, purchased: false),
            ShoppingItem(id: "s2", name: "Banana", quantity: 3, category: fruitCategory, purchased: false),
            ShoppingItem(id: "s3", name: "Orange", quantity: 1, category: fruitCategory, purchased: false)
        ])
    }
    
    func injectInitalValue(categories: Set<Category>, shoppingItems: Set<ShoppingItem>) {
        self.categories = categories
        self.shoppingItems = shoppingItems
    }
    
    func addPredefinedError() {
        self.errorToThrow = ShoppingListTestError.predefinedError
    }
    
    private func incrementCalledAndThrowIfNeeded() throws {
        calledCount += 1
        if let errorToThrow {
            throw errorToThrow
        }
    }
    
    func getShoppingItems() async throws -> [ShoppingItem] {
        try incrementCalledAndThrowIfNeeded()
        return Array(shoppingItems)
    }
    
    func getShoppingItem(id: String) async throws -> ShoppingItem {
        try incrementCalledAndThrowIfNeeded()
        guard let item = shoppingItems.first(where: { $0.id == id }) else {
            throw ShoppingListTestError.itemNotFound
        }
        return item
    }
    
    func addShoppingItem(_ item: ShoppingItem) async throws {
        try incrementCalledAndThrowIfNeeded()
        shoppingItems.insert(item)
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async throws {
        try incrementCalledAndThrowIfNeeded()
        shoppingItems.insert(item)
    }
    
    func deleteShoppingItem(id: String) async throws {
        try incrementCalledAndThrowIfNeeded()
        if let item = Array(shoppingItems.filter{ $0.id == id }).first {
            shoppingItems.remove(item)
        }
    }
    
    func getCategories() async throws -> [Category] {
        try incrementCalledAndThrowIfNeeded()
        return Array(categories)
    }
    
    func getCategory(id: String) async throws -> Category {
        try incrementCalledAndThrowIfNeeded()
        guard let c = categories.first(where: { $0.id == id }) else {
            throw ShoppingListTestError.itemNotFound
        }
        return c
    }
    
    func addCategory(_ category: Category) async throws {
        try incrementCalledAndThrowIfNeeded()
        categories.insert(category)
    }
    
    func updateCategory(_ category: Category) async throws {
        try incrementCalledAndThrowIfNeeded()
        categories.update(with: category)
    }
    
    func deleteCategory(id: String) async throws {
        try incrementCalledAndThrowIfNeeded()
        if let item = Array(categories.filter{ $0.id == id }).first {
            categories.remove(item)
        }
    }
}
