import SwiftUI

struct EditorialCard: View {
    let editorial: Editorial

    var body: some View {
        HStack(alignment: .top, spacing: PlatedSpacing.md) {
            CachedAsyncImage(url: editorial.thumbnailURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 120, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.image, style: .continuous))

            VStack(alignment: .leading, spacing: PlatedSpacing.xs) {
                Text(editorial.category.displayName.uppercased())
                    .font(PlatedTypography.overline)
                    .tracking(1.2)
                    .foregroundStyle(PlatedColors.terracotta)

                Text(editorial.headline)
                    .font(PlatedTypography.serifHeadline)
                    .foregroundStyle(PlatedColors.deepBrown)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                if let subheadline = editorial.subheadline {
                    Text(subheadline)
                        .font(PlatedTypography.uiCallout)
                        .foregroundStyle(PlatedColors.deepBrownSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                HStack(spacing: PlatedSpacing.xs) {
                    Text("\(editorial.readingTimeMinutes) min read")
                        .font(PlatedTypography.uiCaption2)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)

                    Text("·")
                        .foregroundStyle(PlatedColors.deepBrownTertiary)

                    Text(editorial.author.name)
                        .font(PlatedTypography.uiCaption2)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                }
            }
            .padding(.vertical, PlatedSpacing.xxs)
        }
        .frame(height: 140)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(editorial.headline). \(editorial.category.displayName). \(editorial.readingTimeMinutes) minute read")
    }
}
