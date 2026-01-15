import Foundation

struct CategoryDTO: Identifiable, Codable {
    var id: String
    var name: String
}

struct Category: Identifiable, Codable {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from dto: CategoryDTO) {
        self.id = dto.id
        self.name = dto.name
    }
    
    func toDTO() -> CategoryDTO {
        .init(
            id: id,
            name: name
        )
    }
}

extension CategoryDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension Category: Hashable {
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

