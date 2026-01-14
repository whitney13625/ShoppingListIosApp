import SwiftUI

struct ShoppingItemDetailView: View {
    @Environment(\.dismiss) var dismiss
    private var viewModel: ShoppingListViewModel
    @State private var item: ShoppingItem
    @State private var isNewItem: Bool
    
    init(viewModel: ShoppingListViewModel, shoppingItem: ShoppingItem? = nil) {
        
        self.viewModel = viewModel
        
        if let existing = shoppingItem {
            _item = State(initialValue: existing)
        } else {
            let newItem = ShoppingItem(from: .init(
                id: UUID().uuidString,
                name: "",
                quantity: 1,
                category: viewModel.categories.loadedValue?.first ?? Category(id: "default", name: "Uncategorized"),
                purchased: false
            ))
            _item = State(initialValue: newItem)
        }
        
        _isNewItem = State(initialValue: shoppingItem == nil)
    }
    
    var body: some View {
        
        @Bindable var bindableItem = item
        
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $bindableItem.name)
                    Stepper("Quantity: \(item.quantity)", value: $bindableItem.quantity, in: 1...100)
                    Picker("Category", selection: $bindableItem.category) {
                        ForEach(viewModel.categories.loadedValue ?? []) { category in
                            Text(category.name).tag(category)
                        }
                    }
                    Toggle("Purchased?", isOn: $bindableItem.purchased)
                    .pickerStyle(.menu)
                }
                
                Button(isNewItem ? "Add Item" : "Save Changes") {
                    saveAction()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle(isNewItem ? "Add New Item" : "Edit Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveAction() {
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

// Conformance to Equatable for Category to be used in Picker
extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    ShoppingItemDetailView(viewModel: AppState.stub.makeShoppingListViewModel())
}
