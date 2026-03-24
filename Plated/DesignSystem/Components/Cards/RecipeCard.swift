import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.xs) {
            CachedAsyncImage(url: recipe.thumbnailURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 170, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.image, style: .continuous))

            VStack(alignment: .leading, spacing: PlatedSpacing.xxs) {
                Text(recipe.title)
                    .font(PlatedTypography.serifHeadline)
                    .foregroundStyle(PlatedColors.deepBrown)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: PlatedSpacing.xs) {
                    Text(recipe.formattedTotalTime)
                        .font(PlatedTypography.uiCaption)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)

                    Text("·")
                        .foregroundStyle(PlatedColors.deepBrownTertiary)

                    Text(recipe.difficulty.displayName)
                        .font(PlatedTypography.uiCaption)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                }
            }
            .padding(.horizontal, PlatedSpacing.xxs)
        }
        .frame(width: 170)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(recipe.title). \(recipe.formattedTotalTime). \(recipe.difficulty.displayName)")
    }
}
