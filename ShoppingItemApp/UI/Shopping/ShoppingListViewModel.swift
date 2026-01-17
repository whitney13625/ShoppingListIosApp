
import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
final class ShoppingListViewModel: LoadableViewModelProtocol {
    
    var shoppingItems: Loading<[ShoppingItem]> = .notLoaded
    var categories:  Loading<[Category]> = .notLoaded
    
    private let shoppingRepository: ShoppingRepository
    private let dataSyncService: DataSyncService
    
    init(dataSyncService: DataSyncService, shoppingRepository: ShoppingRepository) {
        self.dataSyncService = dataSyncService
        self.shoppingRepository = shoppingRepository
    }
    
    func resync() async {
        await Task.detached(priority: .background) { [weak self] in
             try? await self?.dataSyncService.sync()
        }.value
    }
    
    func refetch() {
        fetchCategories() // Fetch categories on init
        fetchShoppingItems()
    }
    
    func reload() {
        Task {
            await resync()
            await MainActor.run {
                refetch()
            }
        }
    }
    
    func fetchShoppingItems() {
        performLoad(
            on: \.shoppingItems
        ) { [weak self] in
            guard let self else { return [] }
            return try await self.shoppingRepository.getShoppingItems()
        }
    }
    
    func addShoppingItem(_ item: ShoppingItem) async {
        do {
            try await shoppingRepository.addShoppingItem(item)
        } catch {
            print("Error adding shoping item: \(error.localizedDescription)")
        }
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async {
        do {
            try await shoppingRepository.updateShoppingItem(item)
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
            return try await shoppingRepository.getCategories()
        }
    }
    
    // New: Add category
    func addCategory(_ category: Category) async {
        do {
            try await shoppingRepository.addCategory(category)
            fetchCategories() // Refresh categories after adding
        } catch {
            print("Error adding category: \(error.localizedDescription)")
        }
    }
    
    // New: Update category
    func updateCategory(_ category: Category) async {
        do {
            try await shoppingRepository.updateCategory(category)
            fetchCategories()
        } catch {
            print("Error updating category: \(error.localizedDescription)")
        }
    }
    
    // New: Delete category
    func deleteCategory(_ category: Category) async {
        do {
            try await shoppingRepository.deleteCategory(id: category.id)
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
            try await shoppingRepository.updateShoppingItem(item)
        } catch {
            // Rollback
            item.purchased = originalPurchased
        }
    }
    
    private func updateItems(with items: [ShoppingItem]) {
        let currentItemsById = Dictionary(uniqueKeysWithValues: (shoppingItems.loadedValue ?? []).map { ($0.id, $0) })
        
        let updatedList = items.map { item -> ShoppingItem in
            if let existingItem = currentItemsById[item.id] {
                existingItem.update(from: item)
                return existingItem
            } else {
                return item
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
