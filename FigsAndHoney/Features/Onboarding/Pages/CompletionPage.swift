import SwiftUI

struct CompletionPage: View {
    var body: some View {
        VStack(spacing: FHSpacing.xl) {
            Spacer()

            VStack(spacing: FHSpacing.lg) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 56, weight: .ultraLight))
                    .foregroundStyle(FHColors.sage)

                VStack(spacing: FHSpacing.sm) {
                    Text("You're all set")
                        .font(FHTypography.serifDisplay)
                        .foregroundStyle(FHColors.deepBrown)

                    Text("Your feed is ready.\nTime to discover something beautiful.")
                        .font(FHTypography.serifBody)
                        .foregroundStyle(FHColors.deepBrownSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, FHSpacing.xxl)
    }
}
