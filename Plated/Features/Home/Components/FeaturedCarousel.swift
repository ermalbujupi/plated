import SwiftUI

struct FeaturedCarousel: View {
    let recipes: [Recipe]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: PlatedSpacing.md) {
                ForEach(recipes) { recipe in
                    NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                        FeatureCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                    .containerRelativeFrame(.horizontal, count: 1, spacing: PlatedSpacing.md)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, PlatedSpacing.screenHorizontal, for: .scrollContent)
    }
}
