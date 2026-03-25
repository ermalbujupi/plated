import SwiftUI

struct CollectionCard: View {
    let collection: FoodCollection

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.sm) {
            CachedAsyncImage(url: collection.coverImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 280, height: 180)
            .overlay(alignment: .topTrailing) {
                Text("\(collection.recipeCount) recipes")
                    .font(FHTypography.uiCaption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, FHSpacing.sm)
                    .padding(.vertical, FHSpacing.xxs)
                    .background(.black.opacity(0.5))
                    .clipShape(Capsule())
                    .padding(FHSpacing.sm)
            }
            .clipShape(RoundedRectangle(cornerRadius: FHRadius.image, style: .continuous))

            VStack(alignment: .leading, spacing: FHSpacing.xxs) {
                Text(collection.title)
                    .font(FHTypography.serifHeadline)
                    .foregroundStyle(FHColors.deepBrown)
                    .lineLimit(1)

                if let subtitle = collection.subtitle {
                    Text(subtitle)
                        .font(FHTypography.uiCaption)
                        .foregroundStyle(FHColors.deepBrownTertiary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, FHSpacing.xxs)
        }
        .frame(width: 280)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(collection.title). \(collection.recipeCount) recipes")
    }
}
