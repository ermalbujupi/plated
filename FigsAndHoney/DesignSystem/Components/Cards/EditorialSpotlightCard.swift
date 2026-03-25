import SwiftUI

struct EditorialSpotlightCard: View {
    let editorial: Editorial

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.md) {
            CachedAsyncImage(url: editorial.heroImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: FHRadius.card, style: .continuous))

            VStack(alignment: .leading, spacing: FHSpacing.xs) {
                Text(editorial.category.displayName.uppercased())
                    .font(FHTypography.overline)
                    .tracking(1.5)
                    .foregroundStyle(FHColors.terracotta)

                Text(editorial.headline)
                    .font(FHTypography.serifTitle)
                    .foregroundStyle(FHColors.deepBrown)
                    .lineLimit(3)

                if let subheadline = editorial.subheadline {
                    Text(subheadline)
                        .font(FHTypography.serifCallout)
                        .foregroundStyle(FHColors.deepBrownSecondary)
                        .lineLimit(2)
                }

                HStack(spacing: FHSpacing.xs) {
                    Text("By \(editorial.author.name)")
                        .font(FHTypography.uiCaption)
                        .foregroundStyle(FHColors.deepBrownTertiary)

                    Text("·")
                        .foregroundStyle(FHColors.deepBrownTertiary)

                    Text("\(editorial.readingTimeMinutes) min read")
                        .font(FHTypography.uiCaption)
                        .foregroundStyle(FHColors.deepBrownTertiary)
                }
                .padding(.top, FHSpacing.xxs)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(editorial.headline). By \(editorial.author.name). \(editorial.readingTimeMinutes) minute read")
    }
}
