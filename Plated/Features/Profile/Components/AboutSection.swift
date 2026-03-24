import SwiftUI

struct AboutSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
            Text("About Plated")
                .font(PlatedTypography.serifTitle3)
                .foregroundStyle(PlatedColors.deepBrown)

            VStack(spacing: 0) {
                aboutRow(title: "Version", value: "1.0.0")
                Divider().foregroundStyle(PlatedColors.divider)
                aboutRow(title: "Terms of Service", showChevron: true)
                Divider().foregroundStyle(PlatedColors.divider)
                aboutRow(title: "Privacy Policy", showChevron: true)
                Divider().foregroundStyle(PlatedColors.divider)
                aboutRow(title: "Acknowledgments", showChevron: true)
            }
        }
    }

    private func aboutRow(title: String, value: String? = nil, showChevron: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(PlatedTypography.uiBody)
                .foregroundStyle(PlatedColors.deepBrown)

            Spacer()

            if let value {
                Text(value)
                    .font(PlatedTypography.uiCallout)
                    .foregroundStyle(PlatedColors.deepBrownTertiary)
            }

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(PlatedColors.deepBrownTertiary)
            }
        }
        .padding(.vertical, PlatedSpacing.sm)
    }
}
