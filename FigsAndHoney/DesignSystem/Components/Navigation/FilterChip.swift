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
                .font(FHTypography.uiCaption)
                .foregroundStyle(isSelected ? .white : FHColors.deepBrownSecondary)
                .padding(.horizontal, FHSpacing.md)
                .padding(.vertical, FHSpacing.xs)
                .background(
                    isSelected ? FHColors.deepBrown : FHColors.linen,
                    in: Capsule()
                )
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? Color.clear : FHColors.warmGray,
                            lineWidth: 1
                        )
                )
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
