
struct CategoriesResponse: Codable {
    let count: Int
    let total: Int
    let page: Int
    let totalPages: Int
    let data: [CategoryDTO]
}
