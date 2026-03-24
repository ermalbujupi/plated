import SwiftUI

struct DietarySection: View {
    let selectedRestrictions: Set<UserPreferences.DietaryRestriction>
    let onToggle: (UserPreferences.DietaryRestriction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
            Text("Dietary Preferences")
                .font(PlatedTypography.serifTitle3)
                .foregroundStyle(PlatedColors.deepBrown)

            Text("We'll tailor recommendations to your needs.")
                .font(PlatedTypography.uiCallout)
                .foregroundStyle(PlatedColors.deepBrownTertiary)

            VStack(spacing: 0) {
                ForEach(UserPreferences.DietaryRestriction.allCases, id: \.self) { restriction in
                    PreferenceToggleRow(
                        title: restriction.displayName,
                        isSelected: selectedRestrictions.contains(restriction)
                    ) {
                        onToggle(restriction)
                    }

                    if restriction != UserPreferences.DietaryRestriction.allCases.last {
                        Divider().foregroundStyle(PlatedColors.divider)
                    }
                }
            }
        }
    }
}
