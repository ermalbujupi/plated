import SwiftUI

struct CardStyleModifier: ViewModifier {
    var cornerRadius: CGFloat = FHRadius.card
    var shadow: FHShadow = FHShadows.card

    func body(content: Content) -> some View {
        content
            .background(FHColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .fhShadow(shadow)
    }
}
