import SwiftUI

struct CollectionCard: View {
    let collection: FoodCollection

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
            CachedAsyncImage(url: collection.coverImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 280, height: 180)
            .overlay(alignment: .topTrailing) {
                Text("\(collection.recipeCount) recipes")
                    .font(PlatedTypography.uiCaption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, PlatedSpacing.sm)
                    .padding(.vertical, PlatedSpacing.xxs)
                    .background(.black.opacity(0.5))
                    .clipShape(Capsule())
                    .padding(PlatedSpacing.sm)
            }
            .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.image, style: .continuous))

            VStack(alignment: .leading, spacing: PlatedSpacing.xxs) {
                Text(collection.title)
                    .font(PlatedTypography.serifHeadline)
                    .foregroundStyle(PlatedColors.deepBrown)
                    .lineLimit(1)

                if let subtitle = collection.subtitle {
                    Text(subtitle)
                        .font(PlatedTypography.uiCaption)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, PlatedSpacing.xxs)
        }
        .frame(width: 280)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(collection.title). \(collection.recipeCount) recipes")
    }
}
