import SwiftUI

struct SaveButton: View {
    let isSaved: Bool
    let action: () -> Void
    var size: CGFloat = 22
    var tint: Color = PlatedColors.deepBrown

    var body: some View {
        Button(action: {
            Haptics.light()
            action()
        }) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.system(size: size, weight: .medium))
                .foregroundStyle(isSaved ? PlatedColors.terracotta : tint)
                .contentTransition(.symbolEffect(.replace))
                .animation(.easeInOut(duration: 0.2), value: isSaved)
        }
        .accessibilityLabel(isSaved ? "Remove from saved" : "Save")
        .accessibilityValue(isSaved ? "Saved" : "Not saved")
    }
}
