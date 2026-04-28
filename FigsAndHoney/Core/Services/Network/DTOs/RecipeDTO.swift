import Foundation

/// Wire shape returned by the backend for both list and detail recipe endpoints.
///
/// List endpoints (`/recipes`, `/recipes/featured`) omit `description`,
/// `ingredients`, and `instructions`. Detail endpoint (`/recipes/:id`) includes
/// them. We decode all fields as optional so a single DTO covers both.
///
/// All time fields are *minutes* on the wire; iOS `Recipe` uses `TimeInterval`
/// (seconds), so we multiply by 60 in the mapper.
struct RecipeDTO: Decodable, Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let slug: String?
    let heroImage: String?

    let prepTime: Int?
    let cookTime: Int?
    let totalTime: Int?
    let servings: Int?

    let difficulty: String?
    let course: String?
    let season: String?
    let cuisine: String?
    let isFeatured: Bool?
    let publishedAt: Date?

    let author: AuthorDTO?
    let tags: [TagDTO]?
    let nutrition: NutritionDTO?

    // Detail-only
    let description: String?
    let ingredients: [IngredientDTO]?
    let instructions: [InstructionDTO]?
}

struct NutritionDTO: Decodable, Sendable {
    let calories: Double?
    let protein: Double?
    let carbs: Double?
    let fat: Double?
    let fiber: Double?
    let sugar: Double?
}

struct IngredientDTO: Decodable, Sendable {
    let id: String
    let section: String?
    let name: String
    let quantity: String?
    let unit: String?
    let notes: String?
    let sortOrder: Int?
}

struct InstructionDTO: Decodable, Sendable {
    let id: String
    let stepNumber: Int
    let text: String
    let image: String?
    let tip: String?
}

// MARK: - Mapping to domain model

extension RecipeDTO {
    /// Build the iOS `Recipe` model. Missing fields get safe defaults so the
    /// existing UI doesn't break — list responses produce a "thin" Recipe with
    /// no description/ingredients/instructions, which is fine because list
    /// screens don't read those fields.
    func toModel() -> Recipe {
        Recipe(
            id: id,
            title: title,
            subtitle: subtitle,
            author: author?.toModel() ?? Recipe.placeholderAuthor,
            heroImageURL: heroImage.flatMap(URL.init(string:)) ?? APIFallbacks.imageURL,
            // Backend doesn't expose a separate thumbnail; fall back to hero.
            thumbnailURL: heroImage.flatMap(URL.init(string:)) ?? APIFallbacks.imageURL,
            description: description ?? "",
            // Wire is minutes; model is TimeInterval seconds.
            prepTime: TimeInterval(prepTime ?? 0) * 60,
            cookTime: TimeInterval(cookTime ?? 0) * 60,
            totalTime: TimeInterval(totalTime ?? 0) * 60,
            servings: servings ?? 0,
            difficulty: Self.mapDifficulty(difficulty),
            ingredients: (ingredients ?? []).map { $0.toModel() },
            instructions: (instructions ?? []).map(\.text),
            tags: (tags ?? []).map { $0.toModel() },
            cuisine: cuisine ?? "",
            course: Self.mapCourse(course),
            season: Self.mapSeason(season),
            nutrition: nutrition?.toModel(),
            publishedAt: publishedAt ?? APIFallbacks.publishedAt,
            isFeatured: isFeatured ?? false,
            // Backend doesn't surface related recipes yet; future work.
            relatedRecipeIDs: []
        )
    }

    /// Backend uses `easy | medium | hard`; iOS uses `easy | medium | advanced`.
    private static func mapDifficulty(_ raw: String?) -> Recipe.Difficulty {
        switch raw?.lowercased() {
        case "easy":   return .easy
        case "medium": return .medium
        case "hard", "advanced": return .advanced
        default:       return .medium
        }
    }

    private static func mapCourse(_ raw: String?) -> Recipe.Course {
        // iOS has an extra `appetizer` case the backend doesn't expose.
        Recipe.Course(rawValue: raw?.lowercased() ?? "") ?? .dinner
    }

    /// Backend uses `fall`; iOS uses `autumn`.
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

extension NutritionDTO {
    func toModel() -> NutritionInfo? {
        // If every field is null, treat as "no nutrition info available."
        guard calories != nil || protein != nil || carbs != nil || fat != nil else { return nil }
        return NutritionInfo(
            calories: Int(calories ?? 0),
            protein:  Int(protein ?? 0),
            // Backend `carbs` → iOS `carbohydrates`.
            carbohydrates: Int(carbs ?? 0),
            fat:      Int(fat ?? 0),
            fiber:    fiber.map(Int.init),
            // Backend doesn't track sodium; iOS field stays nil.
            sodium:   nil
        )
    }
}

extension IngredientDTO {
    func toModel() -> Ingredient {
        // iOS `Ingredient.quantity` is a single string. Backend separates
        // quantity ("1 1/2") and unit ("cup"). Stitch them.
        let composedQuantity = [quantity, unit]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        return Ingredient(
            id: id,
            name: name,
            quantity: composedQuantity,
            section: section,
            isOptional: false
        )
    }
}

// MARK: - Placeholder author for thin/orphan responses

private extension Recipe {
    /// Used when the backend returned a recipe without an author payload (shouldn't
    /// happen given current schema, but we don't want to crash if it does).
    static let placeholderAuthor = Author(
        id: "unknown",
        name: "Figs & Honey",
        bio: nil,
        avatarURL: nil,
        role: nil
    )
}
