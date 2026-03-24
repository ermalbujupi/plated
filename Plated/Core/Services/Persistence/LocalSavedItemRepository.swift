import Foundation

actor LocalSavedItemRepository: SavedItemRepository {
    private let key = "plated_saved_items"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func fetchAll() async throws -> [SavedItem] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return try JSONDecoder().decode([SavedItem].self, from: data)
    }

    func save(_ item: SavedItem) async throws {
        var items = try await fetchAll()
        guard !items.contains(where: { $0.contentID == item.contentID }) else { return }
        items.append(item)
        let data = try JSONEncoder().encode(items)
        defaults.set(data, forKey: key)
    }

    func remove(contentID: String) async throws {
        var items = try await fetchAll()
        items.removeAll { $0.contentID == contentID }
        let data = try JSONEncoder().encode(items)
        defaults.set(data, forKey: key)
    }

    func isSaved(contentID: String) async throws -> Bool {
        let items = try await fetchAll()
        return items.contains { $0.contentID == contentID }
    }
}
