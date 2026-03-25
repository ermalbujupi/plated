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
        padding(.horizontal, FHSpacing.screenHorizontal)
    }

    func cardStyle() -> some View {
        background(FHColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: FHRadius.card, style: .continuous))
            .fhShadow(FHShadows.card)
    }
}
