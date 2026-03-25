import SwiftUI

struct RecipeRow: View {
    let title: String
    let subtitle: String?
    let recipes: [Recipe]

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.md) {
            SectionHeader(title: title, subtitle: subtitle, showSeeAll: true)
                .screenHorizontalPadding()

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: FHSpacing.md) {
                    ForEach(recipes) { recipe in
                        NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, FHSpacing.screenHorizontal)
            }
        }
    }
}
