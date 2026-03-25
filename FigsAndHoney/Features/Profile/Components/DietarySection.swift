import SwiftUI

struct DietarySection: View {
    let selectedRestrictions: Set<UserPreferences.DietaryRestriction>
    let onToggle: (UserPreferences.DietaryRestriction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.sm) {
            Text("Dietary Preferences")
                .font(FHTypography.serifTitle3)
                .foregroundStyle(FHColors.deepBrown)

            Text("We'll tailor recommendations to your needs.")
                .font(FHTypography.uiCallout)
                .foregroundStyle(FHColors.deepBrownTertiary)

            VStack(spacing: 0) {
                ForEach(UserPreferences.DietaryRestriction.allCases, id: \.self) { restriction in
                    PreferenceToggleRow(
                        title: restriction.displayName,
                        isSelected: selectedRestrictions.contains(restriction)
                    ) {
                        onToggle(restriction)
                    }

                    if restriction != UserPreferences.DietaryRestriction.allCases.last {
                        Divider().foregroundStyle(FHColors.divider)
                    }
                }
            }
        }
    }
}
