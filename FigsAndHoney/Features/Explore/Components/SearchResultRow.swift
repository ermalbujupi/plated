import SwiftUI

struct SearchResultRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: FHSpacing.md) {
            CachedAsyncImage(url: recipe.thumbnailURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: FHRadius.sm, style: .continuous))

            VStack(alignment: .leading, spacing: FHSpacing.xxs) {
                Text(recipe.title)
                    .font(FHTypography.serifHeadline)
                    .foregroundStyle(FHColors.deepBrown)
                    .lineLimit(2)

                HStack(spacing: FHSpacing.xs) {
                    Text(recipe.formattedTotalTime)
                    Text("·")
                    Text(recipe.difficulty.displayName)
                    Text("·")
                    Text(recipe.cuisine)
                }
                .font(FHTypography.uiCaption)
                .foregroundStyle(FHColors.deepBrownTertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(FHColors.deepBrownTertiary)
        }
    }
}
