struct UserDTO: Codable {
    var id: String
}

struct User: Codable {
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    init(from: UserDTO) {
        id = from.id
    }
}
