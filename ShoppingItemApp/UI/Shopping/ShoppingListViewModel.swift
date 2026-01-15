
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
        reload(showLoading: true)
    }
    
    func reload(showLoading: Bool? = nil) {
        let showLoading = showLoading ?? shoppingItems.loadedValue?.isEmpty ?? true
        fetchCategories(showLoading: showLoading) // Fetch categories on init
        fetchShoppingItems(showLoading: showLoading)
    }
    
    func fetchShoppingItems(showLoading: Bool) {
        performLoad(
            showLoading: showLoading,
            on: \.shoppingItems
        ) { [weak self] in
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
    func fetchCategories(showLoading: Bool? = nil) {
        performLoad(
            showLoading: showLoading ?? categories.loadedValue?.isEmpty ?? true,
            on: \.categories
        ) { [weak self] in
            guard let self else { return [] }
            return try await networkService.fetchCategories().map { .init(from: $0) }
        }
    }
    
    // New: Add category
    func addCategory(_ category: Category) async {
        do {
            _ = try await networkService.addCategory(category.toDTO())
            fetchCategories() // Refresh categories after adding
        } catch {
            print("Error adding category: \(error.localizedDescription)")
        }
    }
    
    // New: Update category
    func updateCategory(_ category: Category) async {
        do {
            _ = try await networkService.updateCategory(category.toDTO())
            fetchCategories()
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
    
    @MainActor
    func toggleItemPurchased(_ item: ShoppingItem) async {
        
        guard let loadedItems = shoppingItems.loadedValue else { return }
        
        let originalPurchased = item.purchased
        
        item.purchased.toggle()
        
        let sortedItems = loadedItems.sorted { !$0.purchased && $1.purchased }
        
        self.shoppingItems = .loaded(sortedItems)

        do {
            try await networkService.updateShoppingItem(item.toDTO())
        } catch {
            // Rollback
            item.purchased = originalPurchased
        }
    }
    
    private func updateItems(with dtos: [ShoppingItem]) {
        let currentItemsById = Dictionary(uniqueKeysWithValues: (shoppingItems.loadedValue ?? []).map { ($0.id, $0) })
        
        let updatedList = dtos.map { dto -> ShoppingItem in
            if let existingItem = currentItemsById[dto.id] {
                existingItem.update(from: dto)
                return existingItem
            } else {
                return dto
            }
        }
        
        self.shoppingItems = .loaded(
            updatedList.sorted {
                if $0.purchased != $1.purchased {
                    return !$0.purchased
                }
                return $0.name < $1.name
            }
        )
    }
}
