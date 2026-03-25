import SwiftUI

struct HomeSectionView: View {
    let section: HomeFeedSection

    var body: some View {
        switch section {
        case .featuredRecipes(let recipes):
            FeaturedCarousel(recipes: recipes)

        case .editorialSpotlight(let editorial):
            NavigationLink(value: Route.editorialDetail(id: editorial.id)) {
                EditorialSpotlightCard(editorial: editorial)
            }
            .buttonStyle(.plain)
            .screenHorizontalPadding()

        case .recipeRow(let title, let subtitle, let recipes):
            RecipeRow(title: title, subtitle: subtitle, recipes: recipes)

        case .suggestionStrip(let suggestions):
            SuggestionStrip(suggestions: suggestions)

        case .collectionHighlight(let collection):
            CollectionRow(collection: collection)

        case .editorialList(let title, let editorials):
            EditorialBlockView(title: title, editorials: editorials)
        }
    }
}
