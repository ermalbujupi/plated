import SwiftUI

struct PreferenceToggleRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            Haptics.selection()
            action()
        }) {
            HStack {
                Text(title)
                    .font(PlatedTypography.uiBody)
                    .foregroundStyle(PlatedColors.deepBrown)

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? PlatedColors.terracotta : PlatedColors.warmGray)
            }
            .padding(.vertical, PlatedSpacing.xs)
        }
    }
}
