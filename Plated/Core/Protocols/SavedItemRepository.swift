import Foundation

protocol SavedItemRepository: Sendable {
    func fetchAll() async throws -> [SavedItem]
    func save(_ item: SavedItem) async throws
    func remove(contentID: String) async throws
    func isSaved(contentID: String) async throws -> Bool
}
