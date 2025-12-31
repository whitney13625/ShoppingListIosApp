//
//  ShoppingItemAppTests.swift
//  ShoppingItemAppTests
//
//  Created by Whitney on 31/12/2025.
//

import Testing
import XCTest // For XCTAssert, etc.
@testable import ShoppingItemApp // Import your app module

final class ShoppingListViewModelTests: XCTestCase {
    var viewModel: ShoppingListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ShoppingListViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchShoppingItems() async {
        // Given initial state
        XCTAssertTrue(viewModel.shoppingItems.isEmpty, "Shopping items should be empty initially")
        
        // When fetching items
        await viewModel.fetchShoppingItems()
        
        // Then items should be loaded (mock data)
        XCTAssertFalse(viewModel.shoppingItems.isEmpty, "Shopping items should not be empty after fetching")
        XCTAssertEqual(viewModel.shoppingItems.count, 3) // Based on mock data
        XCTAssertEqual(viewModel.shoppingItems.first?.name, "Apple")
    }
    
    @MainActor
    func testFetchCategories() async {
        // Given initial state
        XCTAssertTrue(viewModel.categories.isEmpty, "Categories should be empty initially")
        
        // When fetching categories
        await viewModel.fetchCategories()
        
        // Then categories should be loaded (mock data)
        XCTAssertFalse(viewModel.categories.isEmpty, "Categories should not be empty after fetching")
        XCTAssertEqual(viewModel.categories.count, 4) // Based on mock data
        XCTAssertEqual(viewModel.categories.first?.name, "Fruits")
    }
    
    @MainActor
    func testAddCategory() async {
        // Given
        await viewModel.fetchCategories()
        let initialCount = viewModel.categories.count
        let newCategory = Category(id: UUID(), name: "Snacks")
        
        // When
        await viewModel.addCategory(newCategory)
        
        // Then
        XCTAssertEqual(viewModel.categories.count, initialCount + 1, "Category count should increase by 1")
        XCTAssertTrue(viewModel.categories.contains(where: { $0.name == "Snacks" }), "New category should be added")
    }
    
    @MainActor
    func testUpdateCategory() async {
        // Given
        await viewModel.fetchCategories()
        guard let categoryToUpdate = viewModel.categories.first else {
            XCTFail("No categories to update")
            return
        }
        let updatedName = "Tropical Fruits"
        let updatedCategory = Category(id: categoryToUpdate.id, name: updatedName)
        
        // When
        await viewModel.updateCategory(updatedCategory)
        
        // Then
        XCTAssertTrue(viewModel.categories.contains(where: { $0.name == updatedName }), "Category name should be updated")
        XCTAssertFalse(viewModel.categories.contains(where: { $0.name == categoryToUpdate.name && $0.id == categoryToUpdate.id }), "Old category name should not exist")
    }
    
    @MainActor
    func testDeleteCategory() async {
        // Given
        await viewModel.fetchCategories()
        guard let categoryToDelete = viewModel.categories.first else {
            XCTFail("No categories to delete")
            return
        }
        let initialCount = viewModel.categories.count
        
        // When
        await viewModel.deleteCategory(categoryToDelete)
        
        // Then
        XCTAssertEqual(viewModel.categories.count, initialCount - 1, "Category count should decrease by 1")
        XCTAssertFalse(viewModel.categories.contains(where: { $0.id == categoryToDelete.id }), "Category should be deleted")
    }
}
