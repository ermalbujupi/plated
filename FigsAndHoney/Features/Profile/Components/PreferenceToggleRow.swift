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
                    .font(FHTypography.uiBody)
                    .foregroundStyle(FHColors.deepBrown)

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? FHColors.terracotta : FHColors.warmGray)
            }
            .padding(.vertical, FHSpacing.xs)
        }
    }
}
