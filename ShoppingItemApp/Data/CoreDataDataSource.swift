import CoreData

enum CoreDataError: Error {
    case invalidManagedObjectType
}

class CoreDataDataSource: LocalDataSource {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
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
        let request = ShoppingItemEntity.fetchRequest()
        let context = coreDataStack.viewContext
        try await context.perform {
            let itemEntities = try context.fetch(request)
            itemEntities.forEach { context.delete($0) }
            try context.save()
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
