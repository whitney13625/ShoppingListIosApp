import Foundation
import SwiftUI

class ShoppingListViewModel: ObservableObject {
    @Published var shoppingItems: [ShoppingItem] = []
    @Published var categories: [Category] = [] // New property
    
    private let networkService = NetworkService()
    
    init() {
        Task {
            await fetchCategories() // Fetch categories on init
            await fetchShoppingItems()
        }
    }
    
    func fetchShoppingItems() async {
        do {
            // For now, we'll use mock data
            let mockCategory = Category(id: UUID().uuidString, name: "Fruits")
            self.shoppingItems = [
                ShoppingItem(id: UUID().uuidString, name: "Apple", quantity: 2, category: mockCategory),
                ShoppingItem(id: UUID().uuidString, name: "Banana", quantity: 3, category: mockCategory),
                ShoppingItem(id: UUID().uuidString, name: "Orange", quantity: 1, category: mockCategory)
            ]
            
            // In the future, you would use the network service like this:
            // self.shoppingItems = try await networkService.fetchShoppingItems()

        } catch {
            print("Error fetching shopping items: \(error.localizedDescription)")
        }
    }
    
    // New: Fetch categories
    func fetchCategories() async {
        do {
            // Mock categories for now
            self.categories = [
                Category(id: UUID().uuidString, name: "Fruits"),
                Category(id: UUID().uuidString, name: "Vegetables"),
                Category(id: UUID().uuidString, name: "Dairy"),
                Category(id: UUID().uuidString, name: "Meat")
            ]
            // self.categories = try await networkService.fetchCategories()
        } catch {
            print("Error fetching categories: \(error.localizedDescription)")
        }
    }
    
    // New: Add category
    func addCategory(_ category: Category) async {
        do {
            self.categories.append(category) // Mock add
            // _ = try await networkService.addCategory(category)
            // await fetchCategories() // Refresh categories after adding
        } catch {
            print("Error adding category: \(error.localizedDescription)")
        }
    }
    
    // New: Update category
    func updateCategory(_ category: Category) async {
        do {
            if let index = self.categories.firstIndex(where: { $0.id == category.id }) {
                self.categories[index] = category // Mock update
            }
            // _ = try await networkService.updateCategory(category)
            // await fetchCategories() // Refresh categories after updating
        } catch {
            print("Error updating category: \(error.localizedDescription)")
        }
    }
    
    // New: Delete category
    func deleteCategory(_ category: Category) async {
        do {
            self.categories.removeAll { $0.id == category.id } // Mock delete
            // try await networkService.deleteCategory(category)
            // await fetchCategories() // Refresh categories after deleting
        } catch {
            print("Error deleting category: \(error.localizedDescription)")
        }
    }
}
