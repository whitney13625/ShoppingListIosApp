
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
    
    func reload(showLoading: Bool) {
        fetchCategories(showLoading: showLoading) // Fetch categories on init
        fetchShoppingItems(showLoading: showLoading)
    }
    
    func fetchShoppingItems(showLoading: Bool) {
        performLoad(
            showLoading: showLoading ?? shoppingItems.loadedValue?.isEmpty ?? true,
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
    
    @MainActor
    func toggleItemPurchased(_ item: ShoppingItem) async {
        
        guard var loadedItems = shoppingItems.loadedValue else { return }
        
        // 2. 備份原始狀態（回滾用）
        let originalPurchased = item.purchased
        
        // 3. 樂觀更新：直接改物件屬性（觸發 Row UI 更新）
        // 4. 華麗排序：直接對陣列重排並重新賦值給 Loadable
        withAnimation(.spring()) {
            item.purchased.toggle()
            
            // 重新排序陣列
            let sortedItems = loadedItems.sorted { !$0.purchased && $1.purchased }
            
            // 關鍵：將排序後的陣列塞回 Loadable
            // 這不會觸發 Loading 動畫，因為它直接跳過 .loading 狀態
            self.shoppingItems = .loaded(sortedItems)
        }

        do {
            // 5. 呼叫 Node.js API (SQL DELETE/UPDATE)
            try await networkService.updateShoppingItem(item.toDTO())
        } catch {
            // 6. 失敗回滾
            withAnimation {
                item.purchased = originalPurchased
            }
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
