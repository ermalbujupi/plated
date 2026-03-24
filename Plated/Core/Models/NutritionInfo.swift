import Foundation

struct NutritionInfo: Codable, Hashable, Sendable {
    let calories: Int
    let protein: Int
    let carbohydrates: Int
    let fat: Int
    let fiber: Int?
    let sodium: Int?
}
