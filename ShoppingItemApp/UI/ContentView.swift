import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ShoppingListViewModel()
    @State private var showingAddItemSheet = false
    @State private var showingCategoryListSheet = false // New state variable

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.shoppingItems) { item in
                    NavigationLink(destination: ShoppingItemDetailView(viewModel: viewModel, shoppingItem: item)) {
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
            .sheet(isPresented: $showingAddItemSheet) {
                ShoppingItemDetailView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingCategoryListSheet) { // New sheet modifier
                CategoryListView(viewModel: viewModel)
            }
            .onAppear {
                Task {
                    await viewModel.fetchShoppingItems()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
