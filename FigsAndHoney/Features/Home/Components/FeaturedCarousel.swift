import SwiftUI

struct FeaturedCarousel: View {
    let recipes: [Recipe]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: FHSpacing.md) {
                ForEach(recipes) { recipe in
                    NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                        FeatureCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                    .containerRelativeFrame(.horizontal, count: 1, spacing: FHSpacing.md)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, FHSpacing.screenHorizontal, for: .scrollContent)
    }
}
