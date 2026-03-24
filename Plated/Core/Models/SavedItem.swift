import Foundation

struct SavedItem: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let contentType: ContentType
    let contentID: String
    let savedAt: Date

    enum ContentType: String, Codable, Sendable {
        case recipe, editorial, collection, suggestion

        var displayName: String {
            rawValue.capitalized
        }
    }

    init(contentType: ContentType, contentID: String) {
        self.id = UUID().uuidString
        self.contentType = contentType
        self.contentID = contentID
        self.savedAt = Date()
    }

    init(id: String, contentType: ContentType, contentID: String, savedAt: Date) {
        self.id = id
        self.contentType = contentType
        self.contentID = contentID
        self.savedAt = savedAt
    }
}
