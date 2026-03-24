import SwiftUI

struct NutritionBadge: View {
    let nutrition: NutritionInfo

    var body: some View {
        HStack(spacing: PlatedSpacing.lg) {
            nutritionItem("Calories", value: "\(nutrition.calories)")
            nutritionItem("Protein", value: "\(nutrition.protein)g")
            nutritionItem("Carbs", value: "\(nutrition.carbohydrates)g")
            nutritionItem("Fat", value: "\(nutrition.fat)g")
        }
        .padding(PlatedSpacing.md)
        .background(PlatedColors.linen)
        .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.card, style: .continuous))
    }

    private func nutritionItem(_ label: String, value: String) -> some View {
        VStack(spacing: PlatedSpacing.xxs) {
            Text(value)
                .font(PlatedTypography.uiBodyMedium)
                .foregroundStyle(PlatedColors.deepBrown)

            Text(label)
                .font(PlatedTypography.uiCaption2)
                .foregroundStyle(PlatedColors.deepBrownTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}
