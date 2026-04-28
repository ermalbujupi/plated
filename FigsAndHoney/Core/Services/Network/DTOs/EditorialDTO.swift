import Foundation

struct EditorialDTO: Decodable, Sendable {
    let id: String
    let headline: String
    let subheadline: String?
    let slug: String?
    let heroImage: String?
    let category: String?
    let readingTime: Int?
    let isFeatured: Bool?
    let publishedAt: Date?
    let author: AuthorDTO?

    /// Detail-only — list responses don't include blocks.
    let blocks: [EditorialBlockDTO]?
}

/// Wire shape of an editorial block. `content` is heterogeneous JSON whose
/// shape depends on `blockType`, so we decode it as a flexible bag of fields
/// and let the mapper switch on the type.
struct EditorialBlockDTO: Decodable, Sendable {
    let id: String
    let blockType: String
    let sortOrder: Int
    let content: BlockContentDTO
}

struct BlockContentDTO: Decodable, Sendable {
    let text: String?
    let level: Int?
    let url: String?
    let caption: String?
    let recipeId: String?
}

// MARK: - Mapping

extension EditorialDTO {
    func toModel() -> Editorial {
        Editorial(
            id: id,
            headline: headline,
            subheadline: subheadline,
            author: author?.toModel() ?? Author(id: "unknown", name: "Figs & Honey", bio: nil, avatarURL: nil, role: nil),
            heroImageURL: heroImage.flatMap(URL.init(string:)) ?? APIFallbacks.imageURL,
            thumbnailURL: heroImage.flatMap(URL.init(string:)) ?? APIFallbacks.imageURL,
            body: (blocks ?? [])
                .sorted(by: { $0.sortOrder < $1.sortOrder })
                .compactMap { $0.toModel() },
            category: Self.mapCategory(category),
            readingTimeMinutes: readingTime ?? 5,
            publishedAt: publishedAt ?? APIFallbacks.publishedAt,
            isFeatured: isFeatured ?? false,
            relatedRecipeIDs: []
        )
    }

    /// Backend categories: stories, techniques, culture, guides
    /// iOS categories: technique, ingredient, culture, seasonal, interview, guide
    private static func mapCategory(_ raw: String?) -> Editorial.EditorialCategory {
        switch raw?.lowercased() {
        case "techniques": return .technique
        case "culture":    return .culture
        case "guides":     return .guide
        case "stories":    return .interview
        default:           return .guide
        }
    }
}

extension EditorialBlockDTO {
    /// Returns nil if the block can't be mapped (unknown type or missing fields).
    func toModel() -> EditorialBlock? {
        switch blockType {
        case "paragraph":
            guard let text = content.text else { return nil }
            return .paragraph(text)
        case "heading":
            guard let text = content.text else { return nil }
            return .heading(text)
        case "image":
            guard let urlString = content.url, let url = URL(string: urlString) else { return nil }
            return .image(url: url, caption: content.caption)
        case "pull_quote":
            guard let text = content.text else { return nil }
            // Backend doesn't track attribution; iOS optional.
            return .pullQuote(text: text, attribution: nil)
        case "recipe_embed":
            guard let recipeId = content.recipeId else { return nil }
            return .recipeEmbed(recipeID: recipeId)
        default:
            return nil
        }
    }
}
