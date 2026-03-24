import Foundation

struct Ingredient: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let name: String
    let quantity: String
    let section: String?
    let isOptional: Bool

    init(id: String = UUID().uuidString, name: String, quantity: String, section: String? = nil, isOptional: Bool = false) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.section = section
        self.isOptional = isOptional
    }
}
