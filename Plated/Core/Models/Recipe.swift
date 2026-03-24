import Foundation

struct Recipe: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let author: Author
    let heroImageURL: URL
    let thumbnailURL: URL
    let description: String
    let prepTime: TimeInterval
    let cookTime: TimeInterval
    let totalTime: TimeInterval
    let servings: Int
    let difficulty: Difficulty
    let ingredients: [Ingredient]
    let instructions: [String]
    let tags: [Tag]
    let cuisine: String
    let course: Course
    let season: Season?
    let nutrition: NutritionInfo?
    let publishedAt: Date
    let isFeatured: Bool
    let relatedRecipeIDs: [String]

    enum Difficulty: String, Codable, CaseIterable, Sendable {
        case easy, medium, advanced

        var displayName: String {
            rawValue.capitalized
        }
    }

    enum Course: String, Codable, CaseIterable, Sendable {
        case breakfast, lunch, dinner, dessert, snack, drink, appetizer

        var displayName: String {
            rawValue.capitalized
        }
    }

    enum Season: String, Codable, CaseIterable, Sendable {
        case spring, summer, autumn, winter

        var displayName: String {
            rawValue.capitalized
        }
    }

    var formattedTotalTime: String {
        let minutes = Int(totalTime / 60)
        if minutes >= 60 {
            let hours = minutes / 60
            let remaining = minutes % 60
            return remaining > 0 ? "\(hours)h \(remaining)m" : "\(hours)h"
        }
        return "\(minutes) min"
    }

    var formattedPrepTime: String {
        let minutes = Int(prepTime / 60)
        return "\(minutes) min"
    }

    var formattedCookTime: String {
        let minutes = Int(cookTime / 60)
        return "\(minutes) min"
    }
}
