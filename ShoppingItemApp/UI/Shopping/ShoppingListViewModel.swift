import Foundation
import SwiftUI

class ShoppingListViewModel: ObservableObject {
    
    @Published private var __shoppingItems: Loading<[ShoppingItem]> = .notLoaded
    @Published private var __categories: Loading<[Category]> = .notLoaded
    @Published var shoppingItems: Loading<[ShoppingItem]> = .notLoaded
    @Published var categories:  Loading<[Category]> = .notLoaded
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        $__shoppingItems.uiSafeCopy(to: &$shoppingItems)
        $__categories.uiSafeCopy(to: &$categories)
        reload()
    }
    
    func reload() {
        fetchCategories() // Fetch categories on init
        fetchShoppingItems()
    }
    
    func fetchShoppingItems() {
        __shoppingItems.startLoading()
        
        Task {
            await __shoppingItems.load {
                try await networkService.fetchShoppingItems()
            }
        }
    }
    
    func addShoppingItem(_ item: ShoppingItem) async {
        do {
            _ = try await networkService.addShoppingItem(item)
        } catch {
            print("Error adding shoping item: \(error.localizedDescription)")
        }
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async {
        do {
            _ = try await networkService.updateShoppingItem(item)
        } catch {
            print("Error updating shoping item: \(error.localizedDescription)")
        }
    }
    
    // New: Fetch categories
    func fetchCategories() {
        __categories.startLoading()
        
        Task {
            await __categories.load {
                try await networkService.fetchCategories()
            }
        }
    }
    
    // New: Add category
    func addCategory(_ category: Category) async {
        do {
            _ = try await networkService.addCategory(category)
            fetchCategories() // Refresh categories after adding
        } catch {
            print("Error adding category: \(error.localizedDescription)")
        }
    }
    
    // New: Update category
    func updateCategory(_ category: Category) async {
        do {
            _ = try await networkService.updateCategory(category)
            fetchCategories() // Refresh categories after updating
        } catch {
            print("Error updating category: \(error.localizedDescription)")
        }
    }
    
    // New: Delete category
    func deleteCategory(_ category: Category) async {
        do {
            try await networkService.deleteCategory(category.id)
            fetchCategories() // Refresh categories after deleting
        } catch {
            print("Error deleting category: \(error.localizedDescription)")
        }
    }
}
