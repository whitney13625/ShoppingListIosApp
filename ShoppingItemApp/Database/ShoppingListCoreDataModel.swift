import CoreData

class ShoppingListCoreDataModel {
    static let shared = ShoppingListCoreDataModel()

    let model: NSManagedObjectModel = {
        let model = NSManagedObjectModel()

        // Category Entity
        let categoryEntity = NSEntityDescription()
        categoryEntity.name = "CategoryEntity"
        categoryEntity.managedObjectClassName = "CategoryEntity"

        let categoryIdAttr = NSAttributeDescription()
        categoryIdAttr.name = "id"
        categoryIdAttr.attributeType = .stringAttributeType
        categoryIdAttr.isOptional = false
        
        let categoryNameAttr = NSAttributeDescription()
        categoryNameAttr.name = "name"
        categoryNameAttr.attributeType = .stringAttributeType
        categoryNameAttr.isOptional = false

        // ShoppingItem Entity
        let shoppingItemEntity = NSEntityDescription()
        shoppingItemEntity.name = "ShoppingItemEntity"
        shoppingItemEntity.managedObjectClassName = "ShoppingItemEntity"

        let shoppingItemIdAttr = NSAttributeDescription()
        shoppingItemIdAttr.name = "id"
        shoppingItemIdAttr.attributeType = .stringAttributeType
        shoppingItemIdAttr.isOptional = false
        
        let shoppingItemNameAttr = NSAttributeDescription()
        shoppingItemNameAttr.name = "name"
        shoppingItemNameAttr.attributeType = .stringAttributeType
        shoppingItemNameAttr.isOptional = false
        
        let shoppingItemPurchasedAttr = NSAttributeDescription()
        shoppingItemPurchasedAttr.name = "purchased"
        shoppingItemPurchasedAttr.attributeType = .booleanAttributeType
        shoppingItemPurchasedAttr.defaultValue = false
        
        let shoppingItemQuantityAttr = NSAttributeDescription()
        shoppingItemQuantityAttr.name = "quantity"
        shoppingItemQuantityAttr.attributeType = .integer64AttributeType
        shoppingItemQuantityAttr.defaultValue = 1

        // Relationships
        let itemsRelationship = NSRelationshipDescription()
        itemsRelationship.name = "items"
        itemsRelationship.destinationEntity = shoppingItemEntity
        itemsRelationship.isOptional = true
        itemsRelationship.deleteRule = .nullifyDeleteRule
        itemsRelationship.maxCount = 0 // To-many
        
        let categoryRelationship = NSRelationshipDescription()
        categoryRelationship.name = "category"
        categoryRelationship.destinationEntity = categoryEntity
        categoryRelationship.isOptional = true
        categoryRelationship.deleteRule = .nullifyDeleteRule
        categoryRelationship.maxCount = 1 // To-one
        
        itemsRelationship.inverseRelationship = categoryRelationship
        categoryRelationship.inverseRelationship = itemsRelationship

        categoryEntity.properties = [categoryIdAttr, categoryNameAttr, itemsRelationship]
        shoppingItemEntity.properties = [shoppingItemIdAttr, shoppingItemNameAttr, shoppingItemPurchasedAttr, shoppingItemQuantityAttr, categoryRelationship]

        model.entities = [categoryEntity, shoppingItemEntity]
        
        return model
    }()
}
