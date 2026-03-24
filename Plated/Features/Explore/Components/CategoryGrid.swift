import SwiftUI

struct CategoryGrid: View {
    let onCategoryTap: (ExploreCategory) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: PlatedSpacing.sm),
        GridItem(.flexible(), spacing: PlatedSpacing.sm)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: PlatedSpacing.sm) {
            ForEach(ExploreCategory.allCases) { category in
                Button {
                    Haptics.selection()
                    onCategoryTap(category)
                } label: {
                    HStack(spacing: PlatedSpacing.sm) {
                        Image(systemName: category.iconName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(category.color)
                            .frame(width: 32, height: 32)
                            .background(category.color.opacity(0.1))
                            .clipShape(Circle())

                        Text(category.rawValue)
                            .font(PlatedTypography.uiBodyMedium)
                            .foregroundStyle(PlatedColors.deepBrown)
                            .lineLimit(1)

                        Spacer()
                    }
                    .padding(.horizontal, PlatedSpacing.sm)
                    .padding(.vertical, PlatedSpacing.sm)
                    .background(PlatedColors.warmWhite)
                    .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.sm, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: PlatedRadius.sm, style: .continuous)
                            .strokeBorder(PlatedColors.divider, lineWidth: 0.5)
                    )
                }
            }
        }
    }
}
