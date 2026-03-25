import SwiftUI

struct NutritionBadge: View {
    let nutrition: NutritionInfo

    var body: some View {
        HStack(spacing: FHSpacing.lg) {
            nutritionItem("Calories", value: "\(nutrition.calories)")
            nutritionItem("Protein", value: "\(nutrition.protein)g")
            nutritionItem("Carbs", value: "\(nutrition.carbohydrates)g")
            nutritionItem("Fat", value: "\(nutrition.fat)g")
        }
        .padding(FHSpacing.md)
        .background(FHColors.linen)
        .clipShape(RoundedRectangle(cornerRadius: FHRadius.card, style: .continuous))
    }

    private func nutritionItem(_ label: String, value: String) -> some View {
        VStack(spacing: FHSpacing.xxs) {
            Text(value)
                .font(FHTypography.uiBodyMedium)
                .foregroundStyle(FHColors.deepBrown)

            Text(label)
                .font(FHTypography.uiCaption2)
                .foregroundStyle(FHColors.deepBrownTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}
