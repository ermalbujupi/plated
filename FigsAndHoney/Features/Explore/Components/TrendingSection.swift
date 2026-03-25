import SwiftUI

struct TrendingSection: View {
    let recipes: [Recipe]

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.md) {
            SectionHeader(title: "Trending Now", showSeeAll: false)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: FHSpacing.md) {
                    ForEach(recipes) { recipe in
                        NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
