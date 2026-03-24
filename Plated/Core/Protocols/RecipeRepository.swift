import Foundation

protocol RecipeRepository: Sendable {
    func fetchFeatured() async throws -> [Recipe]
    func fetchAll() async throws -> [Recipe]
    func fetchByID(_ id: String) async throws -> Recipe?
    func fetchByCuisine(_ cuisine: String) async throws -> [Recipe]
    func fetchByCourse(_ course: Recipe.Course) async throws -> [Recipe]
    func fetchBySeason(_ season: Recipe.Season) async throws -> [Recipe]
    func search(query: String) async throws -> [Recipe]
}
