import CoreData

enum CoreDataError: Error {
    case invalidManagedObjectType
}

class CoreDataDataSource: LocalDataSource {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    private class BatchImporter: ShoppingItemImporter {
        private let context: NSManagedObjectContext
        private let batchSize = 1000
        private var count = 0
        
        private var categoryCache: [String: NSManagedObjectID]? = nil
        
        init(context: NSManagedObjectContext) {
            self.context = context
            self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        
        private func loadCategoryCache() throws {
            
            var cache: [String: NSManagedObjectID] = [:]
            
            let fetchRequest = CategoryEntity.fetchRequest()
            fetchRequest.propertiesToFetch = ["id"]
            
            let entities = try context.fetch(fetchRequest)
            
            for entity in entities {
                if let id = entity.id {
                    cache[id] = entity.objectID
                }
            }
            
            self.categoryCache = cache
            print("Category Cache built with \(cache.count) items")
        }
        
        func addCategory(id: String, name: String) throws {
            
            let entity = CategoryEntity(context: context)
            entity.id = id
            entity.name = name
            
            try checkBatchSave()
        }
        
        func addShoppingItem(id: String, name: String, quantity: Int, purchased: Bool, categoryId: String?) throws {
            
            let entity = ShoppingItemEntity(context: context)
            entity.id = id
            entity.name = name
            entity.quantity = Int64(quantity)
            entity.purchased = purchased
            
            if let catId = categoryId, let objectID = categoryCache?[catId] {
                let category = try context.existingObject(with: objectID) as? CategoryEntity
                entity.category = category
            }
            
            try checkBatchSave()
        }
        
        func finishAddingCategory() throws {
            try saveAndReset()
            try loadCategoryCache()
        }
        
        func finishAddingShoppingItem() throws {
            try saveAndReset()
        }
        
        private func checkBatchSave() throws {
            count += 1
            if count % batchSize == 0 {
                try saveAndReset()
            }
        }
        
        private func saveAndReset() throws {
            if context.hasChanges {
                do {
                    try context.save()
                    context.reset() // Release memory
                    print("Batch saved and context reset at count: \(count)")
                } catch {
                    print("Save error: \(error)")
                    throw error
                }
            }
        }
        
        fileprivate func finalize() throws {
            try saveAndReset()
        }
    }
    
    private struct CoreDataImporter: ShoppingItemImporter {
        
        let context: NSManagedObjectContext
        
        func addShoppingItem(id: String, name: String, quantity: Int, purchased: Bool, categoryId: String?) throws {
            let entity = ShoppingItemEntity(context: context)
            entity.id = id
            entity.name = name
            entity.quantity = Int64(quantity)
            entity.purchased = purchased
            if let categoryId {
                
                let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", categoryId)
                fetchRequest.fetchLimit = 1
                
                entity.category = try context.fetch(fetchRequest).first
            }
        }
        
        func addCategory(id: String, name: String) throws {
            let entity = CategoryEntity(context: context)
            entity.id = id
            entity.name = name
        }
        
        func finishAddingCategory() throws {
            try saveAndReset()
        }
        func finishAddingShoppingItem() throws {
            try saveAndReset()
        }
        
        private func saveAndReset() throws {
            if context.hasChanges {
                do {
                    try context.save()
                    context.reset() // Release memory
                    print("Saved and context reset")
                } catch {
                    print("Save error: \(error)")
                    throw error
                }
            }
        }
        
        fileprivate func finalize() throws {
            try saveAndReset()
        }
    }
    
    
    func performBatchImport(action: @escaping (ShoppingItemImporter) throws -> Void) async throws {
        let context = coreDataStack.ovdrrideBackgroundContext
        
        try await context.perform {
                
            let importer = BatchImporter(context: context)
            
            try action(importer)
            
            try importer.finalize()
        }
    }
    
    
    func performImport(action: @escaping (ShoppingItemImporter) throws -> Void) async throws {
        let context = coreDataStack.ovdrrideBackgroundContext
        
        try await context.perform {
            
            let importer = CoreDataImporter(context: context)
            
            try action(importer)
                
            try importer.finalize()
        }
    }
    
    // MARK: - Shopping Items

    func getShoppingItems() async throws -> [ShoppingItem] {
        let request = ShoppingItemEntity.fetchRequest()
        let context = coreDataStack.viewContext
        let itemEntities = try await context.perform {
            try context.fetch(request)
        }
        return itemEntities.map { $0.toShoppingItem() }
    }
    
    func getShoppingItem(id: String) async throws -> ShoppingItem {
        let request = ShoppingItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let context = coreDataStack.viewContext
        let itemEntities = try await context.perform {
            try context.fetch(request)
        }
        guard let itemEntity = itemEntities.first else {
            throw CoreDataError.invalidManagedObjectType // Should be a more specific error
        }
        return itemEntity.toShoppingItem()
    }

    func saveShoppingItems(_ items: [ShoppingItem]) async throws {
        let context = coreDataStack.viewContext
        try await context.perform {
            items.forEach { item in
                let itemEntity = ShoppingItemEntity(context: context)
                itemEntity.update(with: item, in: context)
            }
            try context.save()
        }
    }
    
    func addShoppingItem(_ item: ShoppingItem) async throws {
        let context = coreDataStack.viewContext
        try await context.perform {
            let itemEntity = ShoppingItemEntity(context: context)
            itemEntity.update(with: item, in: context)
            try context.save()
        }
    }
    
    func updateShoppingItem(_ item: ShoppingItem) async throws {
        let request = ShoppingItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id)
        let context = coreDataStack.viewContext
        try await context.perform {
            let itemEntities = try context.fetch(request)
            guard let itemEntity = itemEntities.first else {
                // Handle error - item not found
                return
            }
            itemEntity.update(with: item, in: context)
            try context.save()
        }
    }
    
    func deleteShoppingItem(id: String) async throws {
        let request = ShoppingItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let context = coreDataStack.viewContext
        try await context.perform {
            let itemEntities = try context.fetch(request)
            guard let itemEntity = itemEntities.first else {
                // Handle error - item not found
                return
            }
            context.delete(itemEntity)
            try context.save()
        }
    }

    func deleteAllShoppingItems() async throws {
        
        let context = coreDataStack.ovdrrideBackgroundContext
        
        try await context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingItemEntity")
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [self.coreDataStack.viewContext]
                )
            }
        }
    }


    // MARK: - Categories
    
    func getCategories() async throws -> [Category] {
        let request = CategoryEntity.fetchRequest()
        let context = coreDataStack.viewContext
        let categoryEntities = try await context.perform {
            try context.fetch(request)
        }
        return categoryEntities.map { $0.toCategory() }
    }

    func getCategory(id: String) async throws -> Category {
        let request = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let context = coreDataStack.viewContext
        let categoryEntities = try await context.perform {
            try context.fetch(request)
        }
        guard let categoryEntity = categoryEntities.first else {
            throw CoreDataError.invalidManagedObjectType // Should be a more specific error
        }
        return categoryEntity.toCategory()
    }
    
    func saveCategories(_ categories: [Category]) async throws {
        let context = coreDataStack.viewContext
        try await context.perform {
            categories.forEach { category in
                let categoryEntity = CategoryEntity(context: context)
                categoryEntity.update(with: category)
            }
            try context.save()
        }
    }

    func addCategory(_ category: Category) async throws {
        let context = coreDataStack.viewContext
        try await context.perform {
            let categoryEntity = CategoryEntity(context: context)
            categoryEntity.update(with: category)
            try context.save()
        }
    }
    
    func updateCategory(_ category: Category) async throws {
        let request = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id)
        let context = coreDataStack.viewContext
        try await context.perform {
            let categoryEntities = try context.fetch(request)
            guard let categoryEntity = categoryEntities.first else {
                // Handle error - category not found
                return
            }
            categoryEntity.update(with: category)
            try context.save()
        }
    }
    
    func deleteCategory(id: String) async throws {
        let request = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let context = coreDataStack.viewContext
        try await context.perform {
            let categoryEntities = try context.fetch(request)
            guard let categoryEntity = categoryEntities.first else {
                // Handle error - category not found
                return
            }
            context.delete(categoryEntity)
            try context.save()
        }
    }
    
    func deleteAllCategories() async throws {
        let request = CategoryEntity.fetchRequest()
        let context = coreDataStack.viewContext
        try await context.perform {
            let categoryEntities = try context.fetch(request)
            categoryEntities.forEach { context.delete($0) }
            try context.save()
        }
    }
}
