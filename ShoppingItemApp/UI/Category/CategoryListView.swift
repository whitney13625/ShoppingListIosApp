import SwiftUI

struct CategoryListView: View {
    @Environment(\.dismiss) var dismiss
    private var viewModel: ShoppingListViewModel
    @State private var showingAddCategorySheet = false
    @State private var categoryToEdit: Category?
    @State var error: Error?
    
    init(viewModel: ShoppingListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.categories.loadedValue ?? []) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        Button("Edit") {
                            categoryToEdit = category
                            showingAddCategorySheet = true
                        }
                    }
                }
                .onDelete(perform: deleteCategory)
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        categoryToEdit = nil
                        showingAddCategorySheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCategorySheet) {
                AddEditCategoryView(viewModel: viewModel, category: categoryToEdit)
            }
            .showError(for: $error)
        }
    }
    
    private func deleteCategory(at offsets: IndexSet) {
        // In a real app, you would call viewModel.deleteCategory
        offsets.forEach { index in
            guard let loaded = viewModel.categories.loadedValue,
                    index < loaded.count else {
                return
            }
            Task {
                try await viewModel.deleteCategory(loaded[index])
            }
        }
    }
    
    func deleteCategory(_ category: Category) {
        Task {
            do {
                try await viewModel.deleteCategory(category)
            } catch {
                self.error = error
            }
        }
    }
}

struct AddEditCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var categoryName: String
    private var viewModel: ShoppingListViewModel
    private var categoryToEdit: Category?
    @State var error: Error?
    
    init(viewModel: ShoppingListViewModel, category: Category? = nil) {
        self.viewModel = viewModel
        _categoryName = State(initialValue: category?.name ?? "")
        self.categoryToEdit = category
        
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Category Name", text: $categoryName)
                Button("Save") {
                    
                }
            }
            .navigationTitle(categoryToEdit == nil ? "Add Category" : "Edit Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .showError(for: $error)
        }
    }
    
    func onSave() {
        Task {
            do {
                if let categoryToEdit = categoryToEdit {
                    let updatedCategory = Category(id: categoryToEdit.id, name: categoryName)
                    try await viewModel.updateCategory(updatedCategory)
                } else {
                    let newCategory = Category(id: UUID().uuidString, name: categoryName)
                    try await viewModel.addCategory(newCategory)
                }
                dismiss()
            } catch {
                self.error = error
            }
        }
    }
}

#Preview {
    CategoryListView(viewModel: AppState.preview.shoppingListViewModel)
}
