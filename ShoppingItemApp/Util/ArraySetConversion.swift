
extension Array where Element: Hashable {
    var set: Set<Element> { .init(self) }
}

extension Set where Element: Hashable {
    var array: [Element] { Array(self) }
}
