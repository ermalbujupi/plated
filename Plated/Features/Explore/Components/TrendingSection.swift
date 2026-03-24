import SwiftUI

struct TrendingSection: View {
    let recipes: [Recipe]

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
            SectionHeader(title: "Trending Now", showSeeAll: false)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: PlatedSpacing.md) {
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
