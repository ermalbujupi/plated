import SwiftUI

struct CategoryGrid: View {
    let onCategoryTap: (ExploreCategory) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: FHSpacing.sm),
        GridItem(.flexible(), spacing: FHSpacing.sm)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: FHSpacing.sm) {
            ForEach(ExploreCategory.allCases) { category in
                Button {
                    Haptics.selection()
                    onCategoryTap(category)
                } label: {
                    HStack(spacing: FHSpacing.sm) {
                        Image(systemName: category.iconName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(category.color)
                            .frame(width: 32, height: 32)
                            .background(category.color.opacity(0.1))
                            .clipShape(Circle())

                        Text(category.rawValue)
                            .font(FHTypography.uiBodyMedium)
                            .foregroundStyle(FHColors.deepBrown)
                            .lineLimit(1)

                        Spacer()
                    }
                    .padding(.horizontal, FHSpacing.sm)
                    .padding(.vertical, FHSpacing.sm)
                    .background(FHColors.warmWhite)
                    .clipShape(RoundedRectangle(cornerRadius: FHRadius.sm, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: FHRadius.sm, style: .continuous)
                            .strokeBorder(FHColors.divider, lineWidth: 0.5)
                    )
                }
            }
        }
    }
}
