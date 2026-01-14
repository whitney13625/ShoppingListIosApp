import Foundation
import Observation

struct ShoppingItemDTO: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    var quantity: Int
    var category: Category
    var purchased: Bool = false
}

@Observable
class ShoppingItem: Identifiable, Codable {
    let id: String
    var name: String
    var quantity: Int
    var category: Category
    var purchased: Bool
    
    init(from dto: ShoppingItemDTO) {
        self.id = dto.id
        self.name = dto.name
        self.quantity = dto.quantity
        self.category = dto.category
        self.purchased = dto.purchased
    }
    
    func toDTO() -> ShoppingItemDTO {
        .init(
            id: id,
            name: name,
            quantity: quantity,
            category: category,
            purchased: purchased
        )
    }
    
    func copy() -> ShoppingItem {
        .init(
            from: .init(
                id: self.id,
                name: self.name,
                quantity: self.quantity,
                category: self.category,
                purchased: self.purchased
            )
        )
    }

    func update(from other: ShoppingItem) {
        self.name = other.name
        self.quantity = other.quantity
        self.category = other.category
        self.purchased = other.purchased
    }
}
