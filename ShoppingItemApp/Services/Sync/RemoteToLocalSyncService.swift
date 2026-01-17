
protocol DataSyncService {
    func sync() async throws
}

class RemoteToLocalSyncService: DataSyncService {
    private let networkService: NetworkService
    private let localDataSource: LocalDataSource

    init(networkService: NetworkService, localDataSource: LocalDataSource) {
        self.networkService = networkService
        self.localDataSource = localDataSource
    }
    
    func sync() async throws {
        
        try await localDataSource.deleteAllShoppingItems()
        try await localDataSource.deleteAllCategories()
        
        let cloudShoppingItems = try await networkService.fetchShoppingItems()
        let cloudCategoryItems = try await networkService.fetchCategories()
    
        try await localDataSource.performBatchImport() { importer in
            for cat in cloudCategoryItems {
                try importer.addCategory(id: cat.id, name: cat.name)
            }
            try importer.finishAddingCategory()
            
            for item in cloudShoppingItems {
                try importer.addShoppingItem(id: item.id, name: item.name, quantity: item.quantity, purchased: item.purchased, categoryId: item.category.id)
            }
            try importer.finishAddingShoppingItem()
        }
    }
}

protocol ShoppingItemImporter {
    func addCategory(id: String, name: String) throws
    func addShoppingItem(id: String, name: String, quantity: Int, purchased: Bool, categoryId: String?) throws
    func finishAddingCategory() throws
    func finishAddingShoppingItem() throws
}

