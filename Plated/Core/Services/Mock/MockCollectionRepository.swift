import Foundation

final class MockCollectionRepository: CollectionRepository, Sendable {
    private let loader: MockDataLoader

    init(loader: MockDataLoader = MockDataLoader()) {
        self.loader = loader
    }

    func fetchAll() async throws -> [FoodCollection] {
        try await Task.sleep(for: .milliseconds(300))
        return try loader.load("collections")
    }

    func fetchByID(_ id: String) async throws -> FoodCollection? {
        try await Task.sleep(for: .milliseconds(200))
        let all: [FoodCollection] = try loader.load("collections")
        return all.first { $0.id == id }
    }
}
