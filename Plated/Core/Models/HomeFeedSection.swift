import Foundation

enum HomeFeedSection: Identifiable, Sendable {
    case featuredRecipes([Recipe])
    case editorialSpotlight(Editorial)
    case recipeRow(title: String, subtitle: String?, recipes: [Recipe])
    case suggestionStrip([Suggestion])
    case collectionHighlight(FoodCollection)
    case editorialList(title: String, editorials: [Editorial])

    var id: String {
        switch self {
        case .featuredRecipes:
            return "featured-recipes"
        case .editorialSpotlight(let editorial):
            return "editorial-spotlight-\(editorial.id)"
        case .recipeRow(let title, _, _):
            return "recipe-row-\(title.lowercased().replacingOccurrences(of: " ", with: "-"))"
        case .suggestionStrip:
            return "suggestion-strip"
        case .collectionHighlight(let collection):
            return "collection-\(collection.id)"
        case .editorialList(let title, _):
            return "editorial-list-\(title.lowercased().replacingOccurrences(of: " ", with: "-"))"
        }
    }
}
