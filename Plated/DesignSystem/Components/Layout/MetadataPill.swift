import SwiftUI

struct MetadataPill: View {
    let icon: String
    let text: String
    var style: PillStyle = .default

    enum PillStyle {
        case `default`, light, accent

        var foregroundColor: Color {
            switch self {
            case .default: return PlatedColors.deepBrownSecondary
            case .light: return .white.opacity(0.9)
            case .accent: return PlatedColors.terracotta
            }
        }

        var backgroundColor: Color {
            switch self {
            case .default: return PlatedColors.linen
            case .light: return .white.opacity(0.15)
            case .accent: return PlatedColors.terracotta.opacity(0.1)
            }
        }
    }

    var body: some View {
        HStack(spacing: PlatedSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))

            Text(text)
                .font(PlatedTypography.uiCaption2)
        }
        .foregroundStyle(style.foregroundColor)
        .padding(.horizontal, PlatedSpacing.xs)
        .padding(.vertical, PlatedSpacing.xxs)
        .background(style.backgroundColor)
        .clipShape(Capsule())
    }
}
