import SwiftUI

struct CategoryListView: View {
    @Environment(\.dismiss) var dismiss
    private var viewModel: ShoppingListViewModel
    @State private var showingAddCategorySheet = false
    @State private var categoryToEdit: Category?
    
    init(viewModel: ShoppingListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
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
                await viewModel.deleteCategory(loaded[index])
            }
        }
    }
}

struct AddEditCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var categoryName: String
    private var viewModel: ShoppingListViewModel
    private var categoryToEdit: Category?
    
    init(viewModel: ShoppingListViewModel, category: Category? = nil) {
        self.viewModel = viewModel
        _categoryName = State(initialValue: category?.name ?? "")
        self.categoryToEdit = category
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Category Name", text: $categoryName)
                Button("Save") {
                    Task {
                        if let categoryToEdit = categoryToEdit {
                            let updatedCategory = Category(id: categoryToEdit.id, name: categoryName)
                            await viewModel.updateCategory(updatedCategory)
                        } else {
                            let newCategory = Category(id: UUID().uuidString, name: categoryName)
                            await viewModel.addCategory(newCategory)
                        }
                        dismiss()
                    }
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
        }
    }
}

#Preview {
    CategoryListView(viewModel: AppState.stub.makeShoppingListViewModel())
}
