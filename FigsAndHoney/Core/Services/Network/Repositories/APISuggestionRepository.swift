import Foundation

struct APISuggestionRepository: SuggestionRepository {
    let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchAll() async throws -> [Suggestion] {
        // /suggestions returns `data: [...]` directly (no pagination).
        let dtos: [SuggestionDTO] = try await client.get("suggestions")
        return dtos.map { $0.toModel() }
    }

    func fetchByCategory(_ category: Suggestion.SuggestionCategory) async throws -> [Suggestion] {
        // Filter client-side. Backend's category enum doesn't 1:1 match iOS's,
        // so passing a query param wouldn't be reliable. Lists are tiny.
        let all = try await fetchAll()
        return all.filter { $0.category == category }
    }
}
