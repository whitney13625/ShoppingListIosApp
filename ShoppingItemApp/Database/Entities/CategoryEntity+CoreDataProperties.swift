import Foundation
import CoreData

extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension CategoryEntity {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ShoppingItemEntity)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ShoppingItemEntity)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension CategoryEntity : Identifiable {

}
