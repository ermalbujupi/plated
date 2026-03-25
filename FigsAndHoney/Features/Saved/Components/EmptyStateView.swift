import SwiftUI

struct EmptyStateView: View {
    var icon: String = "bookmark"
    var title: String = "Nothing saved yet"
    var message: String = "Save recipes, stories, and collections to find them here later."

    var body: some View {
        VStack(spacing: FHSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(FHColors.warmGray)

            VStack(spacing: FHSpacing.xs) {
                Text(title)
                    .font(FHTypography.serifTitle3)
                    .foregroundStyle(FHColors.deepBrown)

                Text(message)
                    .font(FHTypography.uiCallout)
                    .foregroundStyle(FHColors.deepBrownTertiary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 260)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, FHSpacing.xxxxl)
    }
}
