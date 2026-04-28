import Foundation

struct SuggestionDTO: Decodable, Sendable {
    let id: String
    let title: String
    let prompt: String?
    let image: String?
    let category: String?
    let linkedRecipeId: String?
    let linkedCollectionId: String?
    let isActive: Bool?
    let sortOrder: Int?
    let createdAt: Date?
}

extension SuggestionDTO {
    func toModel() -> Suggestion {
        Suggestion(
            id: id,
            title: title,
            prompt: prompt ?? "",
            imageURL: image.flatMap(URL.init(string:)) ?? APIFallbacks.imageURL,
            category: Self.mapCategory(category),
            linkedRecipeID: linkedRecipeId,
            linkedCollectionID: linkedCollectionId,
            // Backend doesn't store an accent color; iOS treats it as optional.
            accentColorHex: nil,
            publishedAt: createdAt ?? APIFallbacks.publishedAt
        )
    }

    /// Backend categories: quick_meals, seasonal, skill_builder, mood
    /// iOS categories: seasonal, trending, quickMeal, weeknight, entertaining, pantryStaple
    private static func mapCategory(_ raw: String?) -> Suggestion.SuggestionCategory {
        switch raw?.lowercased() {
        case "quick_meals":   return .quickMeal
        case "seasonal":      return .seasonal
        case "skill_builder": return .pantryStaple
        case "mood":          return .trending
        default:              return .trending
        }
    }
}
