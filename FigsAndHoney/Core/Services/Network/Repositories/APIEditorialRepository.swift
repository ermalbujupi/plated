import Foundation

struct APIEditorialRepository: EditorialRepository {
    let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchAll() async throws -> [Editorial] {
        // Envelope flattens `{ data, meta }` to top level, so the inner
        // `data` is an array — decode it directly.
        let dtos: [EditorialDTO] = try await client.get(
            "editorials",
            query: ["perPage": "50"]
        )
        return dtos.map { $0.toModel() }
    }

    func fetchByID(_ id: String) async throws -> Editorial? {
        do {
            let dto: EditorialDTO = try await client.get("editorials/\(id)")
            return dto.toModel()
        } catch let APIError.server(_, code, _) where code == "NOT_FOUND" {
            return nil
        }
    }

    func fetchFeatured() async throws -> [Editorial] {
        // No dedicated featured endpoint; filter from list.
        let all = try await fetchAll()
        return all.filter(\.isFeatured)
    }

    func search(query: String) async throws -> [Editorial] {
        // Backend doesn't have an editorial search endpoint yet; client-side filter
        // for now. Cheap because list is small.
        let all = try await fetchAll()
        let needle = query.lowercased()
        guard !needle.isEmpty else { return all }
        return all.filter { editorial in
            editorial.headline.lowercased().contains(needle) ||
            (editorial.subheadline?.lowercased().contains(needle) ?? false)
        }
    }
}
