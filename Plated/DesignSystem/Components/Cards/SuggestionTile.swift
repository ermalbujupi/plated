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
            RoundedRectangle(cornerRadius: PlatedRadius.card, style: .continuous)
                .fill(.black.opacity(0.35))
        }
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: PlatedSpacing.xxxs) {
                Text(suggestion.prompt)
                    .font(PlatedTypography.uiCaption)
                    .foregroundStyle(.white.opacity(0.8))

                Text(suggestion.title)
                    .font(PlatedTypography.serifCaption)
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding(PlatedSpacing.sm)
        }
        .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.card, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(suggestion.title). \(suggestion.prompt)")
    }
}
