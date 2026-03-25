import SwiftUI

struct MetadataPill: View {
    let icon: String
    let text: String
    var style: PillStyle = .default

    enum PillStyle {
        case `default`, light, accent

        var foregroundColor: Color {
            switch self {
            case .default: return FHColors.deepBrownSecondary
            case .light: return .white.opacity(0.9)
            case .accent: return FHColors.terracotta
            }
        }

        var backgroundColor: Color {
            switch self {
            case .default: return FHColors.linen
            case .light: return .white.opacity(0.15)
            case .accent: return FHColors.terracotta.opacity(0.1)
            }
        }
    }

    var body: some View {
        HStack(spacing: FHSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))

            Text(text)
                .font(FHTypography.uiCaption2)
        }
        .foregroundStyle(style.foregroundColor)
        .padding(.horizontal, FHSpacing.xs)
        .padding(.vertical, FHSpacing.xxs)
        .background(style.backgroundColor)
        .clipShape(Capsule())
    }
}
