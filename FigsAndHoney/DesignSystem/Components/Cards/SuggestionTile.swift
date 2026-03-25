import SwiftUI

struct SuggestionTile: View {
    let suggestion: Suggestion

    var body: some View {
        CachedAsyncImage(url: suggestion.imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .frame(width: 140, height: 140)
        .overlay {
            RoundedRectangle(cornerRadius: FHRadius.card, style: .continuous)
                .fill(.black.opacity(0.35))
        }
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: FHSpacing.xxxs) {
                Text(suggestion.prompt)
                    .font(FHTypography.uiCaption)
                    .foregroundStyle(.white.opacity(0.8))

                Text(suggestion.title)
                    .font(FHTypography.serifCaption)
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding(FHSpacing.sm)
        }
        .clipShape(RoundedRectangle(cornerRadius: FHRadius.card, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(suggestion.title). \(suggestion.prompt)")
    }
}
