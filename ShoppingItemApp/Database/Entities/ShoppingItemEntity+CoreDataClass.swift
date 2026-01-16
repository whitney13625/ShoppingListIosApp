import Foundation
import CoreData

@objc(ShoppingItemEntity)
public class ShoppingItemEntity: NSManagedObject {
    
    func toShoppingItem() -> ShoppingItem {
        .init(
            id: self.id ?? "",
            name: self.name ?? "",
            quantity: Int(self.quantity),
            category: self.category?.toCategory() ?? .init(id: "", name: "No Category"),
            purchased: self.purchased
        )
    }
    
    func update(with item: ShoppingItem, in context: NSManagedObjectContext) {
        self.id = item.id
        self.name = item.name
        self.quantity = Int64(item.quantity)
        self.purchased = item.purchased
        
        let request = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.category.id)
        if let categoryEntity = try? context.fetch(request).first {
            self.category = categoryEntity
        }
    }
    
}
