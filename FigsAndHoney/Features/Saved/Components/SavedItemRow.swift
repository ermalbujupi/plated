import SwiftUI

struct SavedItemRow: View {
    let item: SavedItem
    let recipe: Recipe?
    let editorial: Editorial?
    let collection: FoodCollection?

    var body: some View {
        HStack(spacing: FHSpacing.md) {
            // Thumbnail
            CachedAsyncImage(url: thumbnailURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: FHRadius.image, style: .continuous))

            VStack(alignment: .leading, spacing: FHSpacing.xxs) {
                Text(item.contentType.displayName.uppercased())
                    .font(FHTypography.overline)
                    .tracking(1.0)
                    .foregroundStyle(FHColors.terracotta)

                Text(title)
                    .font(FHTypography.serifHeadline)
                    .foregroundStyle(FHColors.deepBrown)
                    .lineLimit(2)

                Text(subtitle)
                    .font(FHTypography.uiCaption)
                    .foregroundStyle(FHColors.deepBrownTertiary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(FHColors.deepBrownTertiary)
        }
    }

    private var thumbnailURL: URL? {
        switch item.contentType {
        case .recipe: return recipe?.thumbnailURL
        case .editorial: return editorial?.thumbnailURL
        case .collection: return collection?.coverImageURL
        case .suggestion: return nil
        }
    }

    private var title: String {
        switch item.contentType {
        case .recipe: return recipe?.title ?? "Recipe"
        case .editorial: return editorial?.headline ?? "Story"
        case .collection: return collection?.title ?? "Collection"
        case .suggestion: return "Suggestion"
        }
    }

    private var subtitle: String {
        switch item.contentType {
        case .recipe:
            if let recipe { return "\(recipe.formattedTotalTime) · \(recipe.difficulty.displayName)" }
            return ""
        case .editorial:
            if let editorial { return "\(editorial.readingTimeMinutes) min read" }
            return ""
        case .collection:
            if let collection { return "\(collection.recipeCount) recipes" }
            return ""
        case .suggestion: return ""
        }
    }
}
