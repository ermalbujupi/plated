import Foundation

struct CollectionDTO: Decodable, Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let description: String?
    let slug: String?
    let coverImage: String?
    let season: String?
    let isFeatured: Bool?
    let publishedAt: Date?

    /// Detail-only — list responses have `_count` instead.
    let recipes: [CollectionRecipeDTO]?
}

/// Recipes embedded in a collection detail. Same shape as a `RecipeDTO` summary
/// minus a few fields, plus a `sortOrder`.
struct CollectionRecipeDTO: Decodable, Sendable {
    let sortOrder: Int?
    let id: String
    let title: String
    let subtitle: String?
    let heroImage: String?
    let prepTime: Int?
    let cookTime: Int?
    let totalTime: Int?
    let servings: Int?
    let difficulty: String?
    let course: String?
    let cuisine: String?
    let isFeatured: Bool?
    let publishedAt: Date?
    let author: AuthorDTO?
}

extension CollectionDTO {
    func toModel() -> FoodCollection {
        FoodCollection(
            id: id,
            title: title,
            subtitle: subtitle,
            description: description ?? "",
            coverImageURL: coverImage.flatMap(URL.init(string:)) ?? APIFallbacks.imageURL,
            // iOS just wants the IDs in order. Backend returns full recipes in sortOrder.
            recipeIDs: (recipes ?? [])
                .sorted(by: { ($0.sortOrder ?? 0) < ($1.sortOrder ?? 0) })
                .map(\.id),
            // Backend doesn't surface a curator on collections; nil for now.
            curatedBy: nil,
            season: Self.mapSeason(season),
            publishedAt: publishedAt ?? APIFallbacks.publishedAt,
            isFeatured: isFeatured ?? false
        )
    }

    private static func mapSeason(_ raw: String?) -> Recipe.Season? {
        switch raw?.lowercased() {
        case "spring": return .spring
        case "summer": return .summer
        case "fall", "autumn": return .autumn
        case "winter": return .winter
        default:       return nil
        }
    }
}
