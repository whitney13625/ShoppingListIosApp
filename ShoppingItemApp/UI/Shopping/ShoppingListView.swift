import SwiftUI

struct ShoppingListView: View {
    @Environment(AppState.self) private var appState
    
    @State private var viewModel: ShoppingListViewModel?
    
    var body: some View {
        Group {
            if let viewModel {
                ShoppingListContentView(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .task {
            if viewModel == nil {
                viewModel = appState.dependencies.makeShoppingListViewModel()
            }
        }
    }
}

struct ShoppingListContentView: View {
    
    fileprivate let viewModel: ShoppingListViewModel
    @State private var showingAddItemSheet = false
    @State private var showingCategoryListSheet = false
    
    var body: some View {
        NavigationStack {
            shoppingList
                .navigationTitle("Shopping List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Manage Categories") {
                            showingCategoryListSheet = true
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddItemSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .showAddItem(binding: $showingAddItemSheet, viewModel: viewModel)
                .sheet(isPresented: $showingCategoryListSheet) {
                    CategoryListView(viewModel: viewModel)
                }
                .refreshable {
                    viewModel.reload()
                }
                .task {
                    viewModel.reload()
                }
        }
    }
    
    @ViewBuilder
    var shoppingList: some View {
        List {
            
            if viewModel.shoppingItems.isLoading {
                Text("Loading...")
            } else if viewModel.shoppingItems.isFailed {
                Text("Loading failed")
            }
            else if let loaded = viewModel.shoppingItems.loadedValue {
                if loaded.isEmpty {
                    Text("Create your first item")
                }
                else {
                    ForEach(loaded) { item in
                        NavigationLink(destination: ShoppingItemDetailView(viewModel: viewModel, shoppingItem: item)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text("Quantity: \(item.quantity)")
                                        .font(.subheadline)
                                    Text("Category: \(item.category.name)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("Purchased?")
                                    Toggle("",
                                           isOn: Binding(
                                                    get: { item.purchased },
                                                    set: { newValue in
                                                        Task {
                                                            await viewModel.toggleItemPurchased(item)
                                                        }
                                                    }
                                                 )
                                    )
                                }
                            }
                        }
                    }
                }
            }
            else {
                Text("Unhandled case")
            }
        }
        .animation(.default, value: viewModel.shoppingItems.loadedValue)
    }
}

fileprivate extension View {
    func showAddItem(binding: Binding<Bool>, viewModel: ShoppingListViewModel) -> some View {
        modifier(ShowAddItemViewModifier(showingAddItemSheet: binding, viewModel: viewModel))
    }
}

fileprivate struct ShowAddItemViewModifier: ViewModifier {
    
    @Environment(AppState.self) private var appState
    @Binding fileprivate var showingAddItemSheet: Bool
    fileprivate var viewModel: ShoppingListViewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showingAddItemSheet) {
                ShoppingItemDetailView(viewModel: viewModel)
        }
    }
}

#Preview {
    ShoppingListContentView(viewModel: AppState.preview.dependencies.makeShoppingListViewModel())
}
