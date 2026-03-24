import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func screenHorizontalPadding() -> some View {
        padding(.horizontal, PlatedSpacing.screenHorizontal)
    }

    func cardStyle() -> some View {
        background(PlatedColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.card, style: .continuous))
            .platedShadow(PlatedShadows.card)
    }
}
