import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var showSeeAll: Bool = false
    var onSeeAll: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.xxs) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(PlatedTypography.serifTitle3)
                    .foregroundStyle(PlatedColors.deepBrown)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                if showSeeAll {
                    Button(action: { onSeeAll?() }) {
                        Text("See All")
                            .font(PlatedTypography.uiCaption)
                            .foregroundStyle(PlatedColors.terracotta)
                    }
                }
            }

            if let subtitle {
                Text(subtitle)
                    .font(PlatedTypography.uiCallout)
                    .foregroundStyle(PlatedColors.deepBrownTertiary)
            }
        }
    }
}
