import SwiftUI

struct ShoppingItemDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    private var viewModel: ShoppingListViewModel
    
    let originalItem: ShoppingItem?
    @State private var draftItem: ShoppingItem
    
    private var isNewItem: Bool {
        originalItem == nil
    }
    
    init(viewModel: ShoppingListViewModel, shoppingItem: ShoppingItem? = nil) {
        
        self.viewModel = viewModel
        self.originalItem = shoppingItem
        
        if let existing = shoppingItem {
            _draftItem = State(initialValue: existing.copy())
        } else {
            let newItem = ShoppingItem(
                id: UUID().uuidString,
                name: "",
                quantity: 1,
                category: viewModel.categories.loadedValue?.first ?? Category(id: "default", name: "Uncategorized"),
                purchased: false
            )
            _draftItem = State(initialValue: newItem)
        }
    }
    
    var body: some View {
        
        @Bindable var bindableItem = draftItem
        
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $bindableItem.name)
                    Stepper("Quantity: \(bindableItem.quantity)", value: $bindableItem.quantity, in: 1...100)
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
            if let original = originalItem {
                original.update(from: draftItem)
                await viewModel.updateShoppingItem(original)
            }
            else {
                await viewModel.addShoppingItem(draftItem)
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
    ShoppingItemDetailView(viewModel: AppState.preview.shoppingListViewModel)
}
