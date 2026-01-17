import Foundation
import CoreData

@objc(CategoryEntity)
public class CategoryEntity: NSManagedObject {
    
    func toCategory() -> Category {
        Category(id: self.id ?? "", name: self.name ?? "")
    }
    
    func update(with category: Category) {
        self.id = category.id
        self.name = category.name
    }
    
}
