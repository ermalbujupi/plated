import SwiftUI

struct DietaryPreferencePage: View {
    let selected: Set<UserPreferences.DietaryRestriction>
    let onToggle: (UserPreferences.DietaryRestriction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.xl) {
            VStack(alignment: .leading, spacing: PlatedSpacing.xs) {
                Text("Any dietary\npreferences?")
                    .font(PlatedTypography.serifDisplay)
                    .foregroundStyle(PlatedColors.deepBrown)

                Text("Select all that apply. You can always change these later.")
                    .font(PlatedTypography.uiCallout)
                    .foregroundStyle(PlatedColors.deepBrownTertiary)
            }

            FlowLayout(spacing: PlatedSpacing.xs) {
                ForEach(UserPreferences.DietaryRestriction.allCases, id: \.self) { restriction in
                    FilterChip(
                        title: restriction.displayName,
                        isSelected: selected.contains(restriction)
                    ) {
                        onToggle(restriction)
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, PlatedSpacing.screenHorizontal)
        .padding(.top, PlatedSpacing.xl)
    }
}
