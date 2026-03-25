import SwiftUI

struct FHButton: View {
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
                .font(FHTypography.uiBodyMedium)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, FHSpacing.sm)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: FHRadius.button, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: FHRadius.button, style: .continuous)
                        .strokeBorder(borderColor, lineWidth: style == .secondary ? 1 : 0)
                )
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return FHColors.deepBrown
        case .tertiary: return FHColors.terracotta
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return FHColors.deepBrown
        case .secondary: return .clear
        case .tertiary: return .clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary: return .clear
        case .secondary: return FHColors.warmGray
        case .tertiary: return .clear
        }
    }
}
