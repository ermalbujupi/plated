import Foundation

protocol EditorialRepository: Sendable {
    func fetchAll() async throws -> [Editorial]
    func fetchByID(_ id: String) async throws -> Editorial?
    func fetchFeatured() async throws -> [Editorial]
    func search(query: String) async throws -> [Editorial]
}
