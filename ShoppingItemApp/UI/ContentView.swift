import SwiftUI

struct ContentView: View {
    
    @Environment(AppState.self) private var appState
    @StateObject var viewModel: ShoppingListViewModel
    @State private var showingAddItemSheet = false
    @State private var showingCategoryListSheet = false // New state variable

    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: appState.makeShoppingListViewModel())
    }
    
    var body: some View {
        NavigationView {
            shoppingList
                .navigationTitle("Shopping List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { // New toolbar item
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
                    CategoryListView(appState: appState)
                }
                .onAppear {
                    viewModel.fetchShoppingItems()
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
                        NavigationLink(destination: ShoppingItemDetailView(appState: appState, shoppingItem: item)) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("Quantity: \(item.quantity)")
                                    .font(.subheadline)
                                Text("Category: \(item.category.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            else {
                Text("Unhandled case")
            }
        }
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
    @ObservedObject fileprivate var viewModel: ShoppingListViewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showingAddItemSheet) {
                ShoppingItemDetailView(appState: appState)
        }
    }
}

#Preview {
    ContentView(appState: .stub)
}
