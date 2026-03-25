import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var showSeeAll: Bool = false
    var onSeeAll: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.xxs) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(FHTypography.serifTitle3)
                    .foregroundStyle(FHColors.deepBrown)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                if showSeeAll {
                    Button(action: { onSeeAll?() }) {
                        Text("See All")
                            .font(FHTypography.uiCaption)
                            .foregroundStyle(FHColors.terracotta)
                    }
                }
            }

            if let subtitle {
                Text(subtitle)
                    .font(FHTypography.uiCallout)
                    .foregroundStyle(FHColors.deepBrownTertiary)
            }
        }
    }
}
