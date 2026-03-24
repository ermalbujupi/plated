import SwiftUI

struct SearchResultRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: PlatedSpacing.md) {
            CachedAsyncImage(url: recipe.thumbnailURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.sm, style: .continuous))

            VStack(alignment: .leading, spacing: PlatedSpacing.xxs) {
                Text(recipe.title)
                    .font(PlatedTypography.serifHeadline)
                    .foregroundStyle(PlatedColors.deepBrown)
                    .lineLimit(2)

                HStack(spacing: PlatedSpacing.xs) {
                    Text(recipe.formattedTotalTime)
                    Text("·")
                    Text(recipe.difficulty.displayName)
                    Text("·")
                    Text(recipe.cuisine)
                }
                .font(PlatedTypography.uiCaption)
                .foregroundStyle(PlatedColors.deepBrownTertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(PlatedColors.deepBrownTertiary)
        }
    }
}
