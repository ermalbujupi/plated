import Foundation

struct FoodCollection: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let description: String
    let coverImageURL: URL
    let recipeIDs: [String]
    let curatedBy: Author?
    let season: Recipe.Season?
    let publishedAt: Date
    let isFeatured: Bool

    var recipeCount: Int { recipeIDs.count }
}
