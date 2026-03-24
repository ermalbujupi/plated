import SwiftUI

struct CuisinePreferencePage: View {
    let selectedCuisines: Set<String>
    let selectedMoods: Set<UserPreferences.FoodMood>
    let onToggleCuisine: (String) -> Void
    let onToggleMood: (UserPreferences.FoodMood) -> Void

    private let cuisines = ["Italian", "Japanese", "Mexican", "French", "Thai", "Indian", "Mediterranean", "Korean", "American", "Middle Eastern", "Chinese", "Vietnamese"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: PlatedSpacing.xxl) {
                VStack(alignment: .leading, spacing: PlatedSpacing.xs) {
                    Text("What are you\ndrawn to?")
                        .font(PlatedTypography.serifDisplay)
                        .foregroundStyle(PlatedColors.deepBrown)

                    Text("Pick your favorite cuisines and moods.")
                        .font(PlatedTypography.uiCallout)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                }

                VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
                    Text("Cuisines")
                        .font(PlatedTypography.uiSubheadline)
                        .foregroundStyle(PlatedColors.deepBrownSecondary)

                    FlowLayout(spacing: PlatedSpacing.xs) {
                        ForEach(cuisines, id: \.self) { cuisine in
                            FilterChip(
                                title: cuisine,
                                isSelected: selectedCuisines.contains(cuisine)
                            ) {
                                onToggleCuisine(cuisine)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
                    Text("Mood")
                        .font(PlatedTypography.uiSubheadline)
                        .foregroundStyle(PlatedColors.deepBrownSecondary)

                    FlowLayout(spacing: PlatedSpacing.xs) {
                        ForEach(UserPreferences.FoodMood.allCases, id: \.self) { mood in
                            FilterChip(
                                title: mood.displayName,
                                isSelected: selectedMoods.contains(mood)
                            ) {
                                onToggleMood(mood)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, PlatedSpacing.screenHorizontal)
            .padding(.top, PlatedSpacing.xl)
        }
    }
}
