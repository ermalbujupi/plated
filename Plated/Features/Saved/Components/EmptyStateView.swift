import SwiftUI

struct EmptyStateView: View {
    var icon: String = "bookmark"
    var title: String = "Nothing saved yet"
    var message: String = "Save recipes, stories, and collections to find them here later."

    var body: some View {
        VStack(spacing: PlatedSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(PlatedColors.warmGray)

            VStack(spacing: PlatedSpacing.xs) {
                Text(title)
                    .font(PlatedTypography.serifTitle3)
                    .foregroundStyle(PlatedColors.deepBrown)

                Text(message)
                    .font(PlatedTypography.uiCallout)
                    .foregroundStyle(PlatedColors.deepBrownTertiary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 260)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, PlatedSpacing.xxxxl)
    }
}
