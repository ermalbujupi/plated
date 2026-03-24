import Foundation

struct Suggestion: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let title: String
    let prompt: String
    let imageURL: URL
    let category: SuggestionCategory
    let linkedRecipeID: String?
    let linkedCollectionID: String?
    let accentColorHex: String?
    let publishedAt: Date

    enum SuggestionCategory: String, Codable, CaseIterable, Sendable {
        case seasonal, trending, quickMeal, weeknight, entertaining, pantryStaple

        var displayName: String {
            switch self {
            case .seasonal: return "Seasonal"
            case .trending: return "Trending"
            case .quickMeal: return "Quick Meal"
            case .weeknight: return "Weeknight"
            case .entertaining: return "Entertaining"
            case .pantryStaple: return "Pantry Staple"
            }
        }
    }
}
