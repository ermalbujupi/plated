import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: PlatedSpacing.xl) {
            Spacer()

            VStack(spacing: PlatedSpacing.md) {
                Text("Plated")
                    .font(PlatedTypography.serifDisplayLarge)
                    .foregroundStyle(PlatedColors.deepBrown)

                Text("curated food for the senses")
                    .font(PlatedTypography.serifItalic)
                    .foregroundStyle(PlatedColors.deepBrownSecondary)
            }

            VStack(spacing: PlatedSpacing.sm) {
                Text("Discover recipes, stories, and ideas\nthat inspire the way you cook and eat.")
                    .font(PlatedTypography.serifBody)
                    .foregroundStyle(PlatedColors.deepBrownSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, PlatedSpacing.xxl)
    }
}
