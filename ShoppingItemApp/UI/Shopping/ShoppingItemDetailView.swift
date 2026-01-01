import SwiftUI

struct ShoppingItemDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var item: ShoppingItem
    @State private var isNewItem: Bool
    
    // For now, mock categories
    let mockCategories = [
        Category(id: UUID().uuidString, name: "Fruits"),
        Category(id: UUID().uuidString, name: "Vegetables"),
        Category(id: UUID().uuidString, name: "Dairy"),
        Category(id: UUID().uuidString, name: "Meat")
    ]
    
    init(viewModel: ShoppingListViewModel, shoppingItem: ShoppingItem? = nil) {
        self.viewModel = viewModel
        _item = State(initialValue: shoppingItem ?? ShoppingItem(id: UUID().uuidString, name: "", quantity: 1, category: Category(id: UUID().uuidString, name: "Uncategorized")))
        _isNewItem = State(initialValue: shoppingItem == nil)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $item.name)
                    Stepper("Quantity: \(item.quantity)", value: $item.quantity, in: 1...100)
                    Picker("Category", selection: $item.category) {
                        ForEach(mockCategories) { category in
                            Text(category.name).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Button("Save") {
                    Task {
                        if isNewItem {
                            await viewModel.addShoppingItem(item)
                        } else {
                            await viewModel.updateShoppingItem(item)
                        }
                        dismiss()
                    }
                }
            }
            .navigationTitle(isNewItem ? "Add New Item" : "Edit Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Conformance to Equatable for Category to be used in Picker
extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    ShoppingItemDetailView(viewModel: ShoppingListViewModel())
}
