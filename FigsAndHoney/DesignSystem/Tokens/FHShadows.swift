import SwiftUI

struct FHShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum FHShadows {
    static let subtle = FHShadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    static let card = FHShadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    static let elevated = FHShadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 4)
}

struct FHShadowModifier: ViewModifier {
    let shadow: FHShadow

    func body(content: Content) -> some View {
        content.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

extension View {
    func fhShadow(_ shadow: FHShadow) -> some View {
        modifier(FHShadowModifier(shadow: shadow))
    }
}
