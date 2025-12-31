import Foundation

struct ShoppingItem: Identifiable, Codable {
    var id: String
    var name: String
    var quantity: Int
    var category: Category
}
