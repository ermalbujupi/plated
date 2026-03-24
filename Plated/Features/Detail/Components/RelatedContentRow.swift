import SwiftUI

struct RelatedContentRow: View {
    let title: String
    let recipes: [Recipe]

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
            SectionHeader(title: title)
                .screenHorizontalPadding()

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: PlatedSpacing.md) {
                    ForEach(recipes) { recipe in
                        NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, PlatedSpacing.screenHorizontal)
            }
        }
    }
}
