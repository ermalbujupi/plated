import Foundation

struct Tag: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let name: String
    let slug: String
}
