import Foundation

struct Editorial: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let headline: String
    let subheadline: String?
    let author: Author
    let heroImageURL: URL
    let thumbnailURL: URL
    let body: [EditorialBlock]
    let category: EditorialCategory
    let readingTimeMinutes: Int
    let publishedAt: Date
    let isFeatured: Bool
    let relatedRecipeIDs: [String]

    enum EditorialCategory: String, Codable, CaseIterable, Sendable {
        case technique, ingredient, culture, seasonal, interview, guide

        var displayName: String {
            rawValue.capitalized
        }
    }
}

enum EditorialBlock: Codable, Hashable, Sendable {
    case paragraph(String)
    case heading(String)
    case image(url: URL, caption: String?)
    case pullQuote(text: String, attribution: String?)
    case recipeEmbed(recipeID: String)

    private enum CodingKeys: String, CodingKey {
        case type, text, url, caption, attribution, recipeID
    }

    private enum BlockType: String, Codable {
        case paragraph, heading, image, pullQuote, recipeEmbed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(BlockType.self, forKey: .type)

        switch type {
        case .paragraph:
            let text = try container.decode(String.self, forKey: .text)
            self = .paragraph(text)
        case .heading:
            let text = try container.decode(String.self, forKey: .text)
            self = .heading(text)
        case .image:
            let url = try container.decode(URL.self, forKey: .url)
            let caption = try container.decodeIfPresent(String.self, forKey: .caption)
            self = .image(url: url, caption: caption)
        case .pullQuote:
            let text = try container.decode(String.self, forKey: .text)
            let attribution = try container.decodeIfPresent(String.self, forKey: .attribution)
            self = .pullQuote(text: text, attribution: attribution)
        case .recipeEmbed:
            let recipeID = try container.decode(String.self, forKey: .recipeID)
            self = .recipeEmbed(recipeID: recipeID)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .paragraph(let text):
            try container.encode(BlockType.paragraph, forKey: .type)
            try container.encode(text, forKey: .text)
        case .heading(let text):
            try container.encode(BlockType.heading, forKey: .type)
            try container.encode(text, forKey: .text)
        case .image(let url, let caption):
            try container.encode(BlockType.image, forKey: .type)
            try container.encode(url, forKey: .url)
            try container.encodeIfPresent(caption, forKey: .caption)
        case .pullQuote(let text, let attribution):
            try container.encode(BlockType.pullQuote, forKey: .type)
            try container.encode(text, forKey: .text)
            try container.encodeIfPresent(attribution, forKey: .attribution)
        case .recipeEmbed(let recipeID):
            try container.encode(BlockType.recipeEmbed, forKey: .type)
            try container.encode(recipeID, forKey: .recipeID)
        }
    }
}
