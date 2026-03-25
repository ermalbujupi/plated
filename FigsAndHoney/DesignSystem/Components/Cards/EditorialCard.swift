import SwiftUI

struct EditorialCard: View {
    let editorial: Editorial

    var body: some View {
        HStack(alignment: .top, spacing: FHSpacing.md) {
            CachedAsyncImage(url: editorial.thumbnailURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 120, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: FHRadius.image, style: .continuous))

            VStack(alignment: .leading, spacing: FHSpacing.xs) {
                Text(editorial.category.displayName.uppercased())
                    .font(FHTypography.overline)
                    .tracking(1.2)
                    .foregroundStyle(FHColors.terracotta)

                Text(editorial.headline)
                    .font(FHTypography.serifHeadline)
                    .foregroundStyle(FHColors.deepBrown)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                if let subheadline = editorial.subheadline {
                    Text(subheadline)
                        .font(FHTypography.uiCallout)
                        .foregroundStyle(FHColors.deepBrownSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                HStack(spacing: FHSpacing.xs) {
                    Text("\(editorial.readingTimeMinutes) min read")
                        .font(FHTypography.uiCaption2)
                        .foregroundStyle(FHColors.deepBrownTertiary)

                    Text("·")
                        .foregroundStyle(FHColors.deepBrownTertiary)

                    Text(editorial.author.name)
                        .font(FHTypography.uiCaption2)
                        .foregroundStyle(FHColors.deepBrownTertiary)
                }
            }
            .padding(.vertical, FHSpacing.xxs)
        }
        .frame(height: 140)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(editorial.headline). \(editorial.category.displayName). \(editorial.readingTimeMinutes) minute read")
    }
}
