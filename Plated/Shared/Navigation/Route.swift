import Foundation

enum Route: Hashable {
    case recipeDetail(id: String)
    case editorialDetail(id: String)
    case suggestionDetail(id: String)
    case collectionDetail(id: String)
    case search
}
