import SwiftUI

struct FeatureCard: View {
    let recipe: Recipe
    let onSave: (() -> Void)?

    init(recipe: Recipe, onSave: (() -> Void)? = nil) {
        self.recipe = recipe
        self.onSave = onSave
    }

    var body: some View {
        CachedAsyncImage(url: recipe.heroImageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .frame(height: 480)
        .clipped()
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading, spacing: FHSpacing.xs) {
                if let season = recipe.season {
                    Text(season.displayName.uppercased())
                        .font(FHTypography.overline)
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.8))
                }

                Text(recipe.title)
                    .font(FHTypography.serifDisplay)
                    .foregroundStyle(.white)
                    .lineLimit(3)

                if let subtitle = recipe.subtitle {
                    Text(subtitle)
                        .font(FHTypography.uiCallout)
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(2)
                }

                HStack(spacing: FHSpacing.sm) {
                    MetadataPill(icon: "clock", text: recipe.formattedTotalTime, style: .light)
                    MetadataPill(icon: "chart.bar", text: recipe.difficulty.displayName, style: .light)
                }
                .padding(.top, FHSpacing.xxs)
            }
            .padding(FHSpacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: FHRadius.lg, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(recipe.title). \(recipe.formattedTotalTime). \(recipe.difficulty.displayName)")
    }
}
