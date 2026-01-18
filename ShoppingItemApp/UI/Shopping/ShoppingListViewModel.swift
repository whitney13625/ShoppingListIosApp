
import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
final class ShoppingListViewModel: LoadableViewModelProtocol {
    
    var shoppingItems: Loading<[ShoppingItem]> = .notLoaded
    var categories:  Loading<[Category]> = .notLoaded
    
    private let shoppingRepository: ShoppingRepository
    private let networkService: NetworkService
    private let dataSyncService: DataSyncService
    
    init(dataSyncService: DataSyncService, networkService: NetworkService, shoppingRepository: ShoppingRepository) {
        self.dataSyncService = dataSyncService
        self.networkService = networkService
        self.shoppingRepository = shoppingRepository
    }
    
    func resync() async {
        try? await dataSyncService.sync()
    }
    
    @MainActor
    func refetch() async {
        await fetchCategories()
        await fetchShoppingItems()
    }
    
    @MainActor
    func reload() async {
        await resync()
        await refetch()
    }
    
    func fetchShoppingItems() async {
        await performLoad(
            on: \.shoppingItems
        ) { [weak self] in
            guard let self else { return [] }
            return try await self.shoppingRepository.getShoppingItems()
        }
    }
    
    func addShoppingItem(_ item: ShoppingItem) async throws {
        try await networkService.addShoppingItem(item.toDTO())
        try await shoppingRepository.addShoppingItem(item)
        await fetchShoppingItems()
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async throws {
        try await updateItem(item)
        await fetchShoppingItems()
    }
    
    // New: Fetch categories
    func fetchCategories(showLoading: Bool? = nil) async {
        await performLoad(
            showLoading: showLoading ?? categories.loadedValue?.isEmpty ?? true,
            on: \.categories
        ) { [weak self] in
            guard let self else { return [] }
            return try await shoppingRepository.getCategories()
        }
    }
    
    // New: Add category
    func addCategory(_ category: Category) async throws {
        try await networkService.addCategory(category.toDTO())
        try await shoppingRepository.addCategory(category)
        await fetchCategories()
    }
    
    // New: Update category
    func updateCategory(_ category: Category) async throws {
        try await networkService.updateCategory(category.toDTO())
        try await shoppingRepository.updateCategory(category)
        await fetchCategories()
    }
    
    // New: Delete category
    func deleteCategory(_ category: Category) async throws {
        try await networkService.deleteCategory(category.id)
        try await shoppingRepository.deleteCategory(id: category.id)
        await fetchCategories()
    }
    
    @MainActor
    func toggleItemPurchased(_ item: ShoppingItem) async {
        
        guard let loadedItems = shoppingItems.loadedValue else { return }
        
        let originalPurchased = item.purchased
        
        item.purchased.toggle()
        
        let sortedItems = loadedItems.sorted { !$0.purchased && $1.purchased }
        
        self.shoppingItems = .loaded(sortedItems)

        do {
            try await updateItem(item)
            await fetchShoppingItems()
        } catch {
            // Rollback
            item.purchased = originalPurchased
            await fetchShoppingItems()
        }
    }
    
    private func updateItem(_ item: ShoppingItem) async throws {
        try await networkService.updateShoppingItem(item.toDTO())
        try await shoppingRepository.updateShoppingItem(item)
    }
}
