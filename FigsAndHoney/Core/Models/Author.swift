import Foundation

struct Author: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let name: String
    let bio: String?
    let avatarURL: URL?
    let role: String?
}
