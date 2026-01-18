
import Testing
@testable import ShoppingItemApp

struct ShoppingListViewModelTest {
    
    private func makeSUT() async -> (
        viewModel: ShoppingListViewModel,
        repo: MockShoppingRepository,
        network: MockNetworkService,
        sync: MockDataSyncService
    ) {
        let shoppingRepository = MockShoppingRepository()
        let networkService = MockNetworkService()
        let dataSyncService = MockDataSyncService()
        
        shoppingRepository.initialise()
        let vm = await ShoppingListViewModel(
            dataSyncService: dataSyncService,
            networkService: networkService,
            shoppingRepository: shoppingRepository
        )
        return (vm, shoppingRepository, networkService, dataSyncService)
    }
    
    @Test
    func testShoppingItems_InitialState() async throws {
        
        let sut = await makeSUT()
        
        #expect(await sut.viewModel.shoppingItems.loadedValue == nil)
        #expect(await sut.viewModel.categories.loadedValue == nil)
    }
    
    @Test
    func testReload() async throws {
        
        let sut = await makeSUT()
        await sut.viewModel.reload()
        
        try await waitUntil {
            await !sut.viewModel.shoppingItems.isLoading
        }
        
        await #expect(!sut.viewModel.loadedCategories.isEmpty)
        await #expect(!sut.viewModel.loadedShoppingItems.isEmpty)
        
        #expect(sut.sync.calledCount > 0)
    }
    
    @Test
    func testFetchShoppingItems() async throws {
        
        let sut = await makeSUT()
        await sut.viewModel.fetchShoppingItems()
        
        try await waitUntil {
            await !sut.viewModel.shoppingItems.isLoading
        }
        
        await #expect(!sut.viewModel.loadedShoppingItems.isEmpty)
        await #expect(sut.viewModel.loadedShoppingItems.count == 3)
        await #expect(sut.viewModel.loadedShoppingItems.contains(where: {$0.name == "Apple"}))
    }
    
    @Test
    func testFetchShoppingItems_Local_Failed() async throws {
        
        let sut = await makeSUT()
        sut.repo.addPredefinedError()
        
        await sut.viewModel.fetchShoppingItems()
        
        try await waitUntil {
            await !sut.viewModel.shoppingItems.isLoading
        }
        
        await #expect(sut.viewModel.loadedShoppingItems.isEmpty)
        await #expect(sut.viewModel.shoppingItems.isFailed)
    }
    
    @Test
    func testFetchCategories() async throws {
        
        let sut = await makeSUT()
        
        await sut.viewModel.fetchCategories()
        try await waitUntil {
            await !sut.viewModel.categories.isLoading
        }
        
        await #expect(!sut.viewModel.loadedCategories.isEmpty)
        await #expect(sut.viewModel.loadedCategories.count == 4)
        await #expect(sut.viewModel.loadedCategories.contains(where: {$0.name == "Fruits"}))
    }
    
    @Test
    func testFetchCategories_Local_Failed() async throws {
        
        let sut = await makeSUT()
        
        sut.repo.addPredefinedError()
        
        await sut.viewModel.fetchCategories()
        try await waitUntil {
            await !sut.viewModel.categories.isLoading
        }
        
        await #expect(sut.viewModel.loadedCategories.isEmpty)
        await #expect(sut.viewModel.categories.isFailed)
    }
    
    @Test
    func testAddCategory() async throws {
        
        let sut = await makeSUT()
        
        await sut.viewModel.fetchCategories()
        try await waitUntil {
            await !sut.viewModel.categories.isLoading
        }
        
        let originalCount = await sut.viewModel.loadedCategories.count
        try await sut.viewModel.addCategory(.init(id: "c11", name: "Grocery"))
        
        await #expect(sut.viewModel.loadedCategories.count == originalCount + 1)
        await #expect(sut.viewModel.loadedCategories.contains(where: { $0.id == "c11" && $0.name == "Grocery"}))
    }
    
    @Test
    func testAddCategory_Duplicate_Id() async throws {
        
        let sut = await makeSUT()
        
        await sut.viewModel.fetchCategories()
        try await waitUntil {
            await !sut.viewModel.categories.isLoading
        }
        
        let originalCount = await sut.viewModel.loadedCategories.count
        
        try await sut.viewModel.addCategory(.init(id: "c1", name: "Shouldn't add"))
        
        await #expect(sut.viewModel.loadedCategories.count == originalCount)
        await #expect(sut.viewModel.loadedCategories.filter {$0.name == "Shouldn't add"}.isEmpty)
    }
    
    @Test
    func testAddCategory_Network_Fail() async throws {
        
        let sut = await makeSUT()
        sut.network.addPredefinedError()
        
        await sut.viewModel.fetchCategories()
        
        try await waitUntil {
            await !sut.viewModel.categories.isLoading
        }
        
        let originalCount = await sut.viewModel.loadedCategories.count
        
        await #expect(throws: ShoppingListTestError.predefinedError) {
            try await sut.viewModel.addCategory(.init(id: "c11", name: "Grocery"))
        }
        await #expect(sut.viewModel.loadedCategories.count == originalCount)
        await #expect(sut.viewModel.loadedCategories.filter { $0.name == "Grocery" }.isEmpty)
        // sut.repo.calledCount incremented to 1 when fetch
        #expect(sut.repo.calledCount == 1)
    }
    
    //TODO: Test Duplicate Name, which is undefined yet
    
    @Test
    func testUpdateCategory() async throws {
        let sut = await makeSUT()
        
        await sut.viewModel.fetchCategories()
        try await waitUntil {
            await !sut.viewModel.categories.isLoading
        }
        
        let originalCount = await sut.viewModel.loadedCategories.count
        guard let c = await sut.viewModel.loadedCategories.first else {
            return // TODO: HANDLE
        }
        
        let modifiedName = "Modified Name"
        try await sut.viewModel.updateCategory(.init(id: c.id, name: modifiedName))
        
        await #expect(sut.viewModel.loadedCategories.count == originalCount)
        await #expect(sut.viewModel.loadedCategories.contains(where: { $0.id == c.id && $0.name == modifiedName}))
    }
    
    @Test
    func testDeleteCategory() async throws {
        let sut = await makeSUT()
        
        await sut.viewModel.fetchCategories()
        try await waitUntil {
            await !sut.viewModel.categories.isLoading
        }
        
        let originalCount = await sut.viewModel.loadedCategories.count
        guard let c = await sut.viewModel.loadedCategories.first else {
            return // TODO: HANDLE
        }
        
        try await sut.viewModel.deleteCategory(c)
        
        await #expect(sut.viewModel.loadedCategories.count == originalCount - 1)
        
        await #expect(!sut.viewModel.loadedCategories.contains(where: { $0.id == c.id }))
    }
    
    @Test
    func testDeleteCategory_remoteFailed() async throws {
        let sut = await makeSUT()
        sut.network.addPredefinedError()
        
        await sut.viewModel.fetchCategories()
        try await waitUntil {
            await !sut.viewModel.categories.isLoading
        }
        
        guard let c = await sut.viewModel.loadedCategories.first else {
            return // TODO: HANDLE
        }
        
        await #expect(throws: ShoppingListTestError.predefinedError) {
            try await sut.viewModel.deleteCategory(c)
        }
        
        await #expect(sut.viewModel.loadedCategories.contains(where: { $0.id == c.id }))
        // sut.repo.calledCount incremented to 1 when fetch
        #expect(sut.repo.calledCount == 1)
        
    }
}

extension ShoppingListViewModel {
    var loadedShoppingItems: [ShoppingItem] {
        self.shoppingItems.loadedValue ?? []
    }
    
    var loadedCategories: [Category] {
        self.categories.loadedValue ?? []
    }
}

enum ShoppingListTestError: Error {
    case itemNotFound
    case predefinedError
}

