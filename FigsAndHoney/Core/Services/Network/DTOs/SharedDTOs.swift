import Foundation

/// Author DTO returned by every endpoint that includes one.
/// Maps directly to iOS `Author` (with optional bio/role we don't have on the wire).
struct AuthorDTO: Decodable, Sendable {
    let id: String
    let name: String
    let avatarUrl: String?

    func toModel() -> Author {
        Author(
            id: id,
            name: name,
            bio: nil,
            avatarURL: avatarUrl.flatMap(URL.init(string:)),
            role: nil
        )
    }
}

/// Tag DTO. Maps to iOS `Tag`.
struct TagDTO: Decodable, Sendable {
    let id: String
    let name: String
    let slug: String?

    func toModel() -> Tag {
        Tag(id: id, name: name, slug: slug ?? id)
    }
}

/// Centralized fallbacks for fields the backend may return as null but iOS
/// models declare as non-optional. Long term we'd either make iOS optional
/// or ensure the backend always populates — for now this lets us ship.
enum APIFallbacks {
    /// Used when an image URL is missing. iOS image pipeline will fall back to
    /// a default placeholder when this loads (it returns 404).
    static let imageURL = URL(string: "https://placehold.co/800x600/F4EDE3/8B6F47?text=No+Image")!

    /// Used when `publishedAt` is null but iOS expects a Date.
    static let publishedAt = Date(timeIntervalSince1970: 0)
}
