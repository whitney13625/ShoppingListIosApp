import Foundation
import Observation

struct ShoppingItemDTO: Codable, Identifiable {
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
}
