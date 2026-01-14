
import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
final class ShoppingListViewModel: LoadableViewModelProtocol {
    
    var shoppingItems: Loading<[ShoppingItem]> = .notLoaded
    var categories:  Loading<[Category]> = .notLoaded
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        reload()
    }
    
    func reload() {
        fetchCategories() // Fetch categories on init
        fetchShoppingItems()
    }
    
    func fetchShoppingItems() {
        performLoad(on: \.shoppingItems) { [weak self] in
            guard let self else { return [] }
            return try await self.networkService.fetchShoppingItems().map { .init(from: $0) }
        }
    }
    
    func addShoppingItem(_ item: ShoppingItem) async {
        do {
            _ = try await networkService.addShoppingItem(item.toDTO())
        } catch {
            print("Error adding shoping item: \(error.localizedDescription)")
        }
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async {
        do {
            _ = try await networkService.updateShoppingItem(item.toDTO())
        } catch {
            print("Error updating shoping item: \(error.localizedDescription)")
        }
    }
    
    // New: Fetch categories
    func fetchCategories() {
        performLoad(on: \.categories) { [weak self] in
            guard let self else { return [] }
            return try await networkService.fetchCategories()
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
