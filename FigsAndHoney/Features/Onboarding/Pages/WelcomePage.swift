import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: FHSpacing.xl) {
            Spacer()

            VStack(spacing: FHSpacing.md) {
                Text("Figs & Honey")
                    .font(FHTypography.serifDisplayLarge)
                    .foregroundStyle(FHColors.deepBrown)

                Text("curated food for the senses")
                    .font(FHTypography.serifItalic)
                    .foregroundStyle(FHColors.deepBrownSecondary)
            }

            VStack(spacing: FHSpacing.sm) {
                Text("Discover recipes, stories, and ideas\nthat inspire the way you cook and eat.")
                    .font(FHTypography.serifBody)
                    .foregroundStyle(FHColors.deepBrownSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, FHSpacing.xxl)
    }
}
