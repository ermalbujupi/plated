import SwiftUI

struct IngredientListView: View {
    let ingredients: [Ingredient]

    private var groupedIngredients: [(String?, [Ingredient])] {
        var groups: [(String?, [Ingredient])] = []
        var currentSection: String? = nil
        var currentItems: [Ingredient] = []

        for ingredient in ingredients {
            if ingredient.section != currentSection {
                if !currentItems.isEmpty {
                    groups.append((currentSection, currentItems))
                }
                currentSection = ingredient.section
                currentItems = [ingredient]
            } else {
                currentItems.append(ingredient)
            }
        }
        if !currentItems.isEmpty {
            groups.append((currentSection, currentItems))
        }

        return groups
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
            ForEach(Array(groupedIngredients.enumerated()), id: \.offset) { _, group in
                if let sectionName = group.0 {
                    Text(sectionName)
                        .font(PlatedTypography.uiSubheadline)
                        .foregroundStyle(PlatedColors.deepBrown)
                        .padding(.top, PlatedSpacing.xs)
                }

                ForEach(group.1) { ingredient in
                    HStack(alignment: .top) {
                        Text(ingredient.quantity)
                            .font(PlatedTypography.uiBody)
                            .foregroundStyle(PlatedColors.deepBrownTertiary)
                            .frame(width: 80, alignment: .leading)

                        Text(ingredient.name)
                            .font(PlatedTypography.uiBody)
                            .foregroundStyle(PlatedColors.deepBrown)

                        if ingredient.isOptional {
                            Text("optional")
                                .font(PlatedTypography.uiCaption2)
                                .foregroundStyle(PlatedColors.stone)
                                .italic()
                        }

                        Spacer()
                    }
                    .padding(.vertical, PlatedSpacing.xxs)

                    if ingredient.id != group.1.last?.id {
                        Rectangle()
                            .fill(PlatedColors.divider)
                            .frame(height: 0.5)
                    }
                }
            }
        }
    }
}
