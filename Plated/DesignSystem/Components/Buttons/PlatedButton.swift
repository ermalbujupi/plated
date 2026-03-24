import SwiftUI

struct PlatedButton: View {
    let title: String
    var style: ButtonStyle = .primary
    let action: () -> Void

    enum ButtonStyle {
        case primary, secondary, tertiary
    }

    var body: some View {
        Button(action: {
            Haptics.medium()
            action()
        }) {
            Text(title)
                .font(PlatedTypography.uiBodyMedium)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, PlatedSpacing.sm)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: PlatedRadius.button, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: PlatedRadius.button, style: .continuous)
                        .strokeBorder(borderColor, lineWidth: style == .secondary ? 1 : 0)
                )
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return PlatedColors.deepBrown
        case .tertiary: return PlatedColors.terracotta
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return PlatedColors.deepBrown
        case .secondary: return .clear
        case .tertiary: return .clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary: return .clear
        case .secondary: return PlatedColors.warmGray
        case .tertiary: return .clear
        }
    }
}
