import Foundation
import CoreData


extension ShoppingItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItemEntity> {
        return NSFetchRequest<ShoppingItemEntity>(entityName: "ShoppingItemEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var purchased: Bool
    @NSManaged public var quantity: Int64
    @NSManaged public var category: CategoryEntity?

}

extension ShoppingItemEntity : Identifiable {

}

