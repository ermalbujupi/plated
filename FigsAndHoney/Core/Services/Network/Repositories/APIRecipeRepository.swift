import Foundation

/// Real API-backed implementation of `RecipeRepository`.
///
/// Designed to be a drop-in replacement for `MockRecipeRepository` —
/// `DependencyContainer` swaps which one it constructs.
///
/// Note: paginated endpoints return `{ status, data: [...], meta: {...} }`
/// after the backend's response envelope flattens the service-level `{ data,
/// meta }`. So callers decode the array directly; pagination meta isn't
/// surfaced through APIClient yet (the envelope strips it).
struct APIRecipeRepository: RecipeRepository {
    let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    // MARK: - Protocol methods

    func fetchAll() async throws -> [Recipe] {
        let dtos: [RecipeDTO] = try await client.get(
            "recipes",
            query: ["perPage": "50"]
        )
        return dtos.map { $0.toModel() }
    }

    func fetchFeatured() async throws -> [Recipe] {
        let dtos: [RecipeDTO] = try await client.get("recipes/featured")
        return dtos.map { $0.toModel() }
    }

    func fetchByID(_ id: String) async throws -> Recipe? {
        do {
            let dto: RecipeDTO = try await client.get("recipes/\(id)")
            return dto.toModel()
        } catch let APIError.server(_, code, _) where code == "NOT_FOUND" {
            return nil
        }
    }

    func fetchByCuisine(_ cuisine: String) async throws -> [Recipe] {
        let dtos: [RecipeDTO] = try await client.get(
            "recipes",
            query: ["cuisine": cuisine, "perPage": "50"]
        )
        return dtos.map { $0.toModel() }
    }

    func fetchByCourse(_ course: Recipe.Course) async throws -> [Recipe] {
        let dtos: [RecipeDTO] = try await client.get(
            "recipes",
            query: ["course": course.rawValue, "perPage": "50"]
        )
        return dtos.map { $0.toModel() }
    }

    func fetchBySeason(_ season: Recipe.Season) async throws -> [Recipe] {
        // iOS uses `autumn`; backend expects `fall`.
        let wireSeason = season == .autumn ? "fall" : season.rawValue
        let dtos: [RecipeDTO] = try await client.get(
            "recipes",
            query: ["season": wireSeason, "perPage": "50"]
        )
        return dtos.map { $0.toModel() }
    }

    func search(query: String) async throws -> [Recipe] {
        let dtos: [RecipeDTO] = try await client.get(
            "recipes/search",
            query: ["q": query, "perPage": "50"]
        )
        return dtos.map { $0.toModel() }
    }
}
