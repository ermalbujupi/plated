import Foundation

struct UserPreferences: Codable, Sendable {
    var dietaryRestrictions: Set<DietaryRestriction>
    var favoriteCuisines: Set<String>
    var mealInterests: Set<MealInterest>
    var moods: Set<FoodMood>
    var skillLevel: SkillLevel
    var hasCompletedOnboarding: Bool

    enum DietaryRestriction: String, Codable, CaseIterable, Sendable {
        case vegetarian, vegan, glutenFree, dairyFree
        case nutFree, halal, kosher, lowCarb, paleo, keto

        var displayName: String {
            switch self {
            case .glutenFree: return "Gluten-Free"
            case .dairyFree: return "Dairy-Free"
            case .nutFree: return "Nut-Free"
            case .lowCarb: return "Low-Carb"
            default: return rawValue.capitalized
            }
        }
    }

    enum MealInterest: String, Codable, CaseIterable, Sendable {
        case breakfast, brunch, lunch, dinner, snack, dessert, drinks

        var displayName: String {
            rawValue.capitalized
        }
    }

    enum FoodMood: String, Codable, CaseIterable, Sendable {
        case cozy, fresh, indulgent, light, rustic, elegant, adventurous, simple

        var displayName: String {
            rawValue.capitalized
        }
    }

    enum SkillLevel: String, Codable, CaseIterable, Sendable {
        case beginner, intermediate, advanced

        var displayName: String {
            rawValue.capitalized
        }
    }

    static let `default` = UserPreferences(
        dietaryRestrictions: [],
        favoriteCuisines: [],
        mealInterests: [],
        moods: [],
        skillLevel: .intermediate,
        hasCompletedOnboarding: false
    )
}
