import Foundation

final class MockHomeFeedRepository: HomeFeedRepository, Sendable {
    private let loader: MockDataLoader

    init(loader: MockDataLoader = MockDataLoader()) {
        self.loader = loader
    }

    func fetchFeed() async throws -> [HomeFeedSection] {
        try await Task.sleep(for: .milliseconds(500))

        let recipes: [Recipe] = try loader.load("recipes")
        let editorials: [Editorial] = try loader.load("editorials")
        let suggestions: [Suggestion] = try loader.load("suggestions")
        let collections: [FoodCollection] = try loader.load("collections")

        let featured = recipes.filter(\.isFeatured)
        let featuredEditorial = editorials.first(where: \.isFeatured)

        var sections: [HomeFeedSection] = []

        // 1. Featured recipes carousel
        if !featured.isEmpty {
            sections.append(.featuredRecipes(featured))
        }

        // 2. Editorial spotlight
        if let editorial = featuredEditorial {
            sections.append(.editorialSpotlight(editorial))
        }

        // 3. Suggestion strip
        let trendingSuggestions = suggestions.filter { $0.category == .trending || $0.category == .seasonal }
        if !trendingSuggestions.isEmpty {
            sections.append(.suggestionStrip(trendingSuggestions))
        }

        // 4. Quick recipes row
        let quickRecipes = recipes.filter { $0.totalTime <= 1800 } // 30 min or less
        if !quickRecipes.isEmpty {
            sections.append(.recipeRow(
                title: "Under 30 Minutes",
                subtitle: "Quick and beautiful",
                recipes: Array(quickRecipes.prefix(6))
            ))
        }

        // 5. Collection highlight
        if let collection = collections.first(where: \.isFeatured) ?? collections.first {
            sections.append(.collectionHighlight(collection))
        }

        // 6. Seasonal recipes row
        let seasonalRecipes = recipes.filter { $0.season == .spring }
        if !seasonalRecipes.isEmpty {
            sections.append(.recipeRow(
                title: "Spring on the Plate",
                subtitle: "What's good right now",
                recipes: Array(seasonalRecipes.prefix(6))
            ))
        }

        // 7. More suggestions
        let weeknightSuggestions = suggestions.filter { $0.category == .weeknight || $0.category == .quickMeal }
        if !weeknightSuggestions.isEmpty {
            sections.append(.suggestionStrip(weeknightSuggestions))
        }

        // 8. Editorial list
        let otherEditorials = editorials.filter { !$0.isFeatured }
        if !otherEditorials.isEmpty {
            sections.append(.editorialList(
                title: "Worth Reading",
                editorials: Array(otherEditorials.prefix(3))
            ))
        }

        // 9. Dinner recipes
        let dinnerRecipes = recipes.filter { $0.course == .dinner }
        if !dinnerRecipes.isEmpty {
            sections.append(.recipeRow(
                title: "Tonight's Dinner",
                subtitle: "Something worth sitting down for",
                recipes: Array(dinnerRecipes.prefix(6))
            ))
        }

        return sections
    }
}
