import SwiftUI

struct CuisinePreferencePage: View {
    let selectedCuisines: Set<String>
    let selectedMoods: Set<UserPreferences.FoodMood>
    let onToggleCuisine: (String) -> Void
    let onToggleMood: (UserPreferences.FoodMood) -> Void

    private let cuisines = ["Italian", "Japanese", "Mexican", "French", "Thai", "Indian", "Mediterranean", "Korean", "American", "Middle Eastern", "Chinese", "Vietnamese"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: FHSpacing.xxl) {
                VStack(alignment: .leading, spacing: FHSpacing.xs) {
                    Text("What are you\ndrawn to?")
                        .font(FHTypography.serifDisplay)
                        .foregroundStyle(FHColors.deepBrown)

                    Text("Pick your favorite cuisines and moods.")
                        .font(FHTypography.uiCallout)
                        .foregroundStyle(FHColors.deepBrownTertiary)
                }

                VStack(alignment: .leading, spacing: FHSpacing.sm) {
                    Text("Cuisines")
                        .font(FHTypography.uiSubheadline)
                        .foregroundStyle(FHColors.deepBrownSecondary)

                    FlowLayout(spacing: FHSpacing.xs) {
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

                VStack(alignment: .leading, spacing: FHSpacing.sm) {
                    Text("Mood")
                        .font(FHTypography.uiSubheadline)
                        .foregroundStyle(FHColors.deepBrownSecondary)

                    FlowLayout(spacing: FHSpacing.xs) {
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
            .padding(.horizontal, FHSpacing.screenHorizontal)
            .padding(.top, FHSpacing.xl)
        }
    }
}
