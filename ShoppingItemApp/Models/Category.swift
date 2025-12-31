import Foundation

struct Category: Identifiable, Codable {
    var id: String
    var name: String
}

extension Category: Hashable {
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
