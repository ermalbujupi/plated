import Foundation

final class MockSuggestionRepository: SuggestionRepository, Sendable {
    private let loader: MockDataLoader

    init(loader: MockDataLoader = MockDataLoader()) {
        self.loader = loader
    }

    func fetchAll() async throws -> [Suggestion] {
        try await Task.sleep(for: .milliseconds(300))
        return try loader.load("suggestions")
    }

    func fetchByCategory(_ category: Suggestion.SuggestionCategory) async throws -> [Suggestion] {
        try await Task.sleep(for: .milliseconds(200))
        let all: [Suggestion] = try loader.load("suggestions")
        return all.filter { $0.category == category }
    }
}
