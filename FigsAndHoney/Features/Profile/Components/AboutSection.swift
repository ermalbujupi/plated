import SwiftUI

struct AboutSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.sm) {
            Text("About Figs & Honey")
                .font(FHTypography.serifTitle3)
                .foregroundStyle(FHColors.deepBrown)

            VStack(spacing: 0) {
                aboutRow(title: "Version", value: "1.0.0")
                Divider().foregroundStyle(FHColors.divider)
                aboutRow(title: "Terms of Service", showChevron: true)
                Divider().foregroundStyle(FHColors.divider)
                aboutRow(title: "Privacy Policy", showChevron: true)
                Divider().foregroundStyle(FHColors.divider)
                aboutRow(title: "Acknowledgments", showChevron: true)
            }
        }
    }

    private func aboutRow(title: String, value: String? = nil, showChevron: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(FHTypography.uiBody)
                .foregroundStyle(FHColors.deepBrown)

            Spacer()

            if let value {
                Text(value)
                    .font(FHTypography.uiCallout)
                    .foregroundStyle(FHColors.deepBrownTertiary)
            }

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(FHColors.deepBrownTertiary)
            }
        }
        .padding(.vertical, FHSpacing.sm)
    }
}
