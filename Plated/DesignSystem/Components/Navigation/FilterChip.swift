import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            Haptics.selection()
            action()
        }) {
            Text(title)
                .font(PlatedTypography.uiCaption)
                .foregroundStyle(isSelected ? .white : PlatedColors.deepBrownSecondary)
                .padding(.horizontal, PlatedSpacing.md)
                .padding(.vertical, PlatedSpacing.xs)
                .background(
                    isSelected ? PlatedColors.deepBrown : PlatedColors.linen,
                    in: Capsule()
                )
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? Color.clear : PlatedColors.warmGray,
                            lineWidth: 1
                        )
                )
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
