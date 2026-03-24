import SwiftUI

struct CardStyleModifier: ViewModifier {
    var cornerRadius: CGFloat = PlatedRadius.card
    var shadow: PlatedShadow = PlatedShadows.card

    func body(content: Content) -> some View {
        content
            .background(PlatedColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .platedShadow(shadow)
    }
}
