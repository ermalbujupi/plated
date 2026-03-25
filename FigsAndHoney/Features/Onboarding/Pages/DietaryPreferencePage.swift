import SwiftUI

struct DietaryPreferencePage: View {
    let selected: Set<UserPreferences.DietaryRestriction>
    let onToggle: (UserPreferences.DietaryRestriction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.xl) {
            VStack(alignment: .leading, spacing: FHSpacing.xs) {
                Text("Any dietary\npreferences?")
                    .font(FHTypography.serifDisplay)
                    .foregroundStyle(FHColors.deepBrown)

                Text("Select all that apply. You can always change these later.")
                    .font(FHTypography.uiCallout)
                    .foregroundStyle(FHColors.deepBrownTertiary)
            }

            FlowLayout(spacing: FHSpacing.xs) {
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
        .padding(.horizontal, FHSpacing.screenHorizontal)
        .padding(.top, FHSpacing.xl)
    }
}
