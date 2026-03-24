import SwiftUI

struct CompletionPage: View {
    var body: some View {
        VStack(spacing: PlatedSpacing.xl) {
            Spacer()

            VStack(spacing: PlatedSpacing.lg) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 56, weight: .ultraLight))
                    .foregroundStyle(PlatedColors.sage)

                VStack(spacing: PlatedSpacing.sm) {
                    Text("You're all set")
                        .font(PlatedTypography.serifDisplay)
                        .foregroundStyle(PlatedColors.deepBrown)

                    Text("Your feed is ready.\nTime to discover something beautiful.")
                        .font(PlatedTypography.serifBody)
                        .foregroundStyle(PlatedColors.deepBrownSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, PlatedSpacing.xxl)
    }
}
