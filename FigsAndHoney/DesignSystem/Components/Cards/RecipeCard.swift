import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.xs) {
            CachedAsyncImage(url: recipe.thumbnailURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 170, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: FHRadius.image, style: .continuous))

            VStack(alignment: .leading, spacing: FHSpacing.xxs) {
                Text(recipe.title)
                    .font(FHTypography.serifHeadline)
                    .foregroundStyle(FHColors.deepBrown)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: FHSpacing.xs) {
                    Text(recipe.formattedTotalTime)
                        .font(FHTypography.uiCaption)
                        .foregroundStyle(FHColors.deepBrownTertiary)

                    Text("·")
                        .foregroundStyle(FHColors.deepBrownTertiary)

                    Text(recipe.difficulty.displayName)
                        .font(FHTypography.uiCaption)
                        .foregroundStyle(FHColors.deepBrownTertiary)
                }
            }
            .padding(.horizontal, FHSpacing.xxs)
        }
        .frame(width: 170)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(recipe.title). \(recipe.formattedTotalTime). \(recipe.difficulty.displayName)")
    }
}
