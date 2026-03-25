import SwiftUI

struct RecipeDetailView: View {
    @Bindable var viewModel: RecipeDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let recipe = viewModel.recipe {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero image
                    HeroHeaderView(imageURL: recipe.heroImageURL, height: 380)

                    VStack(alignment: .leading, spacing: FHSpacing.xl) {
                        // Header
                        headerSection(recipe)

                        ContentDivider()

                        // Metadata row
                        metadataSection(recipe)

                        ContentDivider()

                        // Description
                        if !recipe.description.isEmpty {
                            Text(recipe.description)
                                .font(FHTypography.serifBody)
                                .foregroundStyle(FHColors.deepBrownSecondary)
                                .lineSpacing(6)
                                .screenHorizontalPadding()
                        }

                        // Ingredients
                        ingredientsSection(recipe)

                        ContentDivider()

                        // Instructions
                        instructionsSection(recipe)

                        // Nutrition
                        if let nutrition = recipe.nutrition {
                            ContentDivider()
                            nutritionSection(nutrition)
                        }

                        // Related recipes
                        if !viewModel.relatedRecipes.isEmpty {
                            ContentDivider()
                            relatedSection
                        }
                    }
                    .padding(.vertical, FHSpacing.xl)
                }
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 400)
            }
        }
        .background(FHColors.cream)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                SaveButton(isSaved: viewModel.isSaved) {
                    Task { await viewModel.toggleSave() }
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private func headerSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: FHSpacing.xs) {
            if let season = recipe.season {
                Text(season.displayName.uppercased())
                    .font(FHTypography.overline)
                    .tracking(1.5)
                    .foregroundStyle(FHColors.terracotta)
            }

            Text(recipe.title)
                .font(FHTypography.serifDisplay)
                .foregroundStyle(FHColors.deepBrown)

            if let subtitle = recipe.subtitle {
                Text(subtitle)
                    .font(FHTypography.serifCallout)
                    .foregroundStyle(FHColors.deepBrownSecondary)
            }

            HStack(spacing: FHSpacing.xs) {
                Text("By \(recipe.author.name)")
                    .font(FHTypography.uiCaption)
                    .foregroundStyle(FHColors.deepBrownTertiary)
            }
            .padding(.top, FHSpacing.xxs)
        }
        .screenHorizontalPadding()
    }

    private func metadataSection(_ recipe: Recipe) -> some View {
        HStack(spacing: FHSpacing.sm) {
            metadataItem(icon: "clock", label: "Total", value: recipe.formattedTotalTime)
            Spacer()
            metadataItem(icon: "flame", label: "Prep", value: recipe.formattedPrepTime)
            Spacer()
            metadataItem(icon: "person.2", label: "Serves", value: "\(recipe.servings)")
            Spacer()
            metadataItem(icon: "chart.bar", label: "Level", value: recipe.difficulty.displayName)
        }
        .screenHorizontalPadding()
    }

    private func metadataItem(icon: String, label: String, value: String) -> some View {
        VStack(spacing: FHSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(FHColors.terracotta)

            Text(value)
                .font(FHTypography.uiBodyMedium)
                .foregroundStyle(FHColors.deepBrown)

            Text(label)
                .font(FHTypography.uiCaption2)
                .foregroundStyle(FHColors.deepBrownTertiary)
        }
    }

    private func ingredientsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: FHSpacing.md) {
            Text("Ingredients")
                .font(FHTypography.serifTitle3)
                .foregroundStyle(FHColors.deepBrown)

            IngredientListView(ingredients: recipe.ingredients)
        }
        .screenHorizontalPadding()
    }

    private func instructionsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: FHSpacing.md) {
            Text("Instructions")
                .font(FHTypography.serifTitle3)
                .foregroundStyle(FHColors.deepBrown)

            VStack(alignment: .leading, spacing: FHSpacing.lg) {
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                    InstructionStepView(stepNumber: index + 1, instruction: step)
                }
            }
        }
        .screenHorizontalPadding()
    }

    private func nutritionSection(_ nutrition: NutritionInfo) -> some View {
        VStack(alignment: .leading, spacing: FHSpacing.md) {
            Text("Nutrition")
                .font(FHTypography.serifTitle3)
                .foregroundStyle(FHColors.deepBrown)

            NutritionBadge(nutrition: nutrition)
        }
        .screenHorizontalPadding()
    }

    private var relatedSection: some View {
        VStack(alignment: .leading, spacing: FHSpacing.md) {
            SectionHeader(title: "You Might Also Like")
                .screenHorizontalPadding()

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: FHSpacing.md) {
                    ForEach(viewModel.relatedRecipes) { recipe in
                        NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, FHSpacing.screenHorizontal)
            }
        }
    }
}
