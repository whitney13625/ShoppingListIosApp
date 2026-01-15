import Foundation
import Observation

struct ShoppingItemDTO: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    var quantity: Int
    var category: CategoryDTO
    var purchased: Bool = false
}

@Observable
class ShoppingItem: Identifiable {
    let id: String
    var name: String
    var quantity: Int
    var category: Category
    var purchased: Bool
    
    init(id: String, name: String, quantity: Int, category: Category, purchased: Bool) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.purchased = purchased
    }
    
    init(from dto: ShoppingItemDTO) {
        self.id = dto.id
        self.name = dto.name
        self.quantity = dto.quantity
        self.category = .init(from: dto.category)
        self.purchased = dto.purchased
    }
    
    func toDTO() -> ShoppingItemDTO {
        .init(
            id: id,
            name: name,
            quantity: quantity,
            category: category.toDTO(),
            purchased: purchased
        )
    }
    
    func copy() -> ShoppingItem {
        .init(
            id: self.id,
            name: self.name,
            quantity: self.quantity,
            category: self.category,
            purchased: self.purchased
        )
    }

    func update(from other: ShoppingItem) {
        self.name = other.name
        self.quantity = other.quantity
        self.category = other.category
        self.purchased = other.purchased
    }
}

extension ShoppingItem: Equatable {
    static func == (lhs: ShoppingItem, rhs: ShoppingItem) -> Bool {
        lhs.id == rhs.id
    }
}
