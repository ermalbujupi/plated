import Foundation

final class MockEditorialRepository: EditorialRepository, Sendable {
    private let loader: MockDataLoader

    init(loader: MockDataLoader = MockDataLoader()) {
        self.loader = loader
    }

    private func allEditorials() throws -> [Editorial] {
        try loader.load("editorials")
    }

    func fetchAll() async throws -> [Editorial] {
        try await Task.sleep(for: .milliseconds(400))
        return try allEditorials()
    }

    func fetchByID(_ id: String) async throws -> Editorial? {
        try await Task.sleep(for: .milliseconds(200))
        return try allEditorials().first { $0.id == id }
    }

    func fetchFeatured() async throws -> [Editorial] {
        try await Task.sleep(for: .milliseconds(300))
        return try allEditorials().filter(\.isFeatured)
    }

    func search(query: String) async throws -> [Editorial] {
        try await Task.sleep(for: .milliseconds(200))
        let lowercased = query.lowercased()
        return try allEditorials().filter { editorial in
            editorial.headline.lowercased().contains(lowercased) ||
            (editorial.subheadline?.lowercased().contains(lowercased) ?? false)
        }
    }
}
