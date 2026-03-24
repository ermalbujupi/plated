import SwiftUI

struct EditorialSpotlightCard: View {
    let editorial: Editorial

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
            CachedAsyncImage(url: editorial.heroImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.card, style: .continuous))

            VStack(alignment: .leading, spacing: PlatedSpacing.xs) {
                Text(editorial.category.displayName.uppercased())
                    .font(PlatedTypography.overline)
                    .tracking(1.5)
                    .foregroundStyle(PlatedColors.terracotta)

                Text(editorial.headline)
                    .font(PlatedTypography.serifTitle)
                    .foregroundStyle(PlatedColors.deepBrown)
                    .lineLimit(3)

                if let subheadline = editorial.subheadline {
                    Text(subheadline)
                        .font(PlatedTypography.serifCallout)
                        .foregroundStyle(PlatedColors.deepBrownSecondary)
                        .lineLimit(2)
                }

                HStack(spacing: PlatedSpacing.xs) {
                    Text("By \(editorial.author.name)")
                        .font(PlatedTypography.uiCaption)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)

                    Text("·")
                        .foregroundStyle(PlatedColors.deepBrownTertiary)

                    Text("\(editorial.readingTimeMinutes) min read")
                        .font(PlatedTypography.uiCaption)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                }
                .padding(.top, PlatedSpacing.xxs)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(editorial.headline). By \(editorial.author.name). \(editorial.readingTimeMinutes) minute read")
    }
}
