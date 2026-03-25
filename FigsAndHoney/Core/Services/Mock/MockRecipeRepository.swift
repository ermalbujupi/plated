import Foundation

final class MockRecipeRepository: RecipeRepository, Sendable {
    private let loader: MockDataLoader

    init(loader: MockDataLoader = MockDataLoader()) {
        self.loader = loader
    }

    private func allRecipes() throws -> [Recipe] {
        try loader.load("recipes")
    }

    func fetchFeatured() async throws -> [Recipe] {
        try await Task.sleep(for: .milliseconds(300))
        return try allRecipes().filter(\.isFeatured)
    }

    func fetchAll() async throws -> [Recipe] {
        try await Task.sleep(for: .milliseconds(400))
        return try allRecipes()
    }

    func fetchByID(_ id: String) async throws -> Recipe? {
        try await Task.sleep(for: .milliseconds(200))
        return try allRecipes().first { $0.id == id }
    }

    func fetchByCuisine(_ cuisine: String) async throws -> [Recipe] {
        try await Task.sleep(for: .milliseconds(300))
        return try allRecipes().filter { $0.cuisine.lowercased() == cuisine.lowercased() }
    }

    func fetchByCourse(_ course: Recipe.Course) async throws -> [Recipe] {
        try await Task.sleep(for: .milliseconds(300))
        return try allRecipes().filter { $0.course == course }
    }

    func fetchBySeason(_ season: Recipe.Season) async throws -> [Recipe] {
        try await Task.sleep(for: .milliseconds(300))
        return try allRecipes().filter { $0.season == season }
    }

    func search(query: String) async throws -> [Recipe] {
        try await Task.sleep(for: .milliseconds(200))
        let lowercased = query.lowercased()
        return try allRecipes().filter { recipe in
            recipe.title.lowercased().contains(lowercased) ||
            recipe.description.lowercased().contains(lowercased) ||
            recipe.cuisine.lowercased().contains(lowercased) ||
            recipe.tags.contains { $0.name.lowercased().contains(lowercased) }
        }
    }
}
