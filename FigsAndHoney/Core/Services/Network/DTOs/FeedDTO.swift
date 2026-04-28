import Foundation

struct FeedResponseDTO: Decodable, Sendable {
    let sections: [FeedSectionDTO]
}

/// A feed section as the backend returns it. `items` is polymorphic — its
/// element shape depends on `sectionType`. We decode `items` as raw JSON
/// (`[AnyDecodable]`) and let the mapper deserialize each item against the
/// expected DTO for that section type.
struct FeedSectionDTO: Decodable, Sendable {
    let id: String
    let sectionType: String
    let title: String?
    let subtitle: String?
    /// Raw JSON values. Re-encoded then decoded as the right DTO in the mapper.
    let items: [AnyJSON]
}

/// A wrapper that captures any JSON value as `Data` so we can re-decode it
/// against a specific DTO type once we know what `sectionType` says it should be.
struct AnyJSON: Decodable, Sendable {
    let raw: Data

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // Easiest path: round-trip through JSONSerialization since Decodable
        // doesn't expose the underlying JSON value directly.
        if let value = try? container.decode(JSONValue.self) {
            self.raw = (try? JSONEncoder().encode(value)) ?? Data()
        } else {
            self.raw = Data()
        }
    }
}

/// Recursive JSON value, used purely as a re-encoding bridge for `AnyJSON`.
indirect enum JSONValue: Codable, Sendable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([JSONValue])
    case object([String: JSONValue])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() { self = .null; return }
        if let v = try? container.decode(Bool.self)              { self = .bool(v); return }
        if let v = try? container.decode(Double.self)            { self = .number(v); return }
        if let v = try? container.decode(String.self)            { self = .string(v); return }
        if let v = try? container.decode([JSONValue].self)       { self = .array(v); return }
        if let v = try? container.decode([String: JSONValue].self) { self = .object(v); return }
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Unrecognized JSON value"
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:           try container.encodeNil()
        case .bool(let v):    try container.encode(v)
        case .number(let v):  try container.encode(v)
        case .string(let v):  try container.encode(v)
        case .array(let v):   try container.encode(v)
        case .object(let v):  try container.encode(v)
        }
    }
}

// MARK: - Mapping

extension FeedResponseDTO {
    /// Map the backend's flat `[FeedSectionDTO]` into iOS's typed
    /// `[HomeFeedSection]` enum. Sections whose type we don't recognize are
    /// silently dropped — the home screen is best-effort.
    func toModel() -> [HomeFeedSection] {
        sections.compactMap { $0.toModel() }
    }
}

extension FeedSectionDTO {
    /// Decode the polymorphic items as the DTO expected for this section type,
    /// then assemble the matching `HomeFeedSection` enum case.
    func toModel() -> HomeFeedSection? {
        // Use the same date strategy as APIClient so re-decoded inner items
        // handle fractional-second ISO8601 timestamps correctly.
        let decoder = APIClient.makeJSONDecoder()

        switch sectionType {
        case "featured_recipe", "recent_recipes":
            let recipes = decodeItems(RecipeDTO.self, with: decoder).map { $0.toModel() }
            guard !recipes.isEmpty else { return nil }
            if sectionType == "featured_recipe" {
                return .featuredRecipes(recipes)
            }
            return .recipeRow(
                title: title ?? "Recipes",
                subtitle: subtitle,
                recipes: recipes
            )

        case "editorial_carousel":
            let editorials = decodeItems(EditorialDTO.self, with: decoder).map { $0.toModel() }
            guard !editorials.isEmpty else { return nil }
            // Single editorial → spotlight; multiple → list. Picks based on item count.
            if editorials.count == 1, let solo = editorials.first {
                return .editorialSpotlight(solo)
            }
            return .editorialList(title: title ?? "Stories", editorials: editorials)

        case "collection_spotlight":
            let collections = decodeItems(CollectionDTO.self, with: decoder).map { $0.toModel() }
            guard let first = collections.first else { return nil }
            return .collectionHighlight(first)

        case "suggestions":
            let suggestions = decodeItems(SuggestionDTO.self, with: decoder).map { $0.toModel() }
            guard !suggestions.isEmpty else { return nil }
            return .suggestionStrip(suggestions)

        default:
            return nil
        }
    }

    /// Decode `items` as the requested DTO type, dropping entries that fail
    /// (so one bad item doesn't kill the whole feed).
    private func decodeItems<T: Decodable>(_ type: T.Type, with decoder: JSONDecoder) -> [T] {
        items.compactMap { wrapper in
            try? decoder.decode(T.self, from: wrapper.raw)
        }
    }
}
