import SwiftUI

struct PlatedShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum PlatedShadows {
    static let subtle = PlatedShadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    static let card = PlatedShadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    static let elevated = PlatedShadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 4)
}

struct PlatedShadowModifier: ViewModifier {
    let shadow: PlatedShadow

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
    func platedShadow(_ shadow: PlatedShadow) -> some View {
        modifier(PlatedShadowModifier(shadow: shadow))
    }
}
