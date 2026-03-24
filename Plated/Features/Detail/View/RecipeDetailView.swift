import SwiftUI

struct RecipeDetailView: View {
    @Bindable var viewModel: RecipeDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let recipe = viewModel.recipe {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero image
                    HeroHeaderView(imageURL: recipe.heroImageURL, height: 380)

                    VStack(alignment: .leading, spacing: PlatedSpacing.xl) {
                        // Header
                        headerSection(recipe)

                        ContentDivider()

                        // Metadata row
                        metadataSection(recipe)

                        ContentDivider()

                        // Description
                        if !recipe.description.isEmpty {
                            Text(recipe.description)
                                .font(PlatedTypography.serifBody)
                                .foregroundStyle(PlatedColors.deepBrownSecondary)
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
                    .padding(.vertical, PlatedSpacing.xl)
                }
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 400)
            }
        }
        .background(PlatedColors.cream)
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
        VStack(alignment: .leading, spacing: PlatedSpacing.xs) {
            if let season = recipe.season {
                Text(season.displayName.uppercased())
                    .font(PlatedTypography.overline)
                    .tracking(1.5)
                    .foregroundStyle(PlatedColors.terracotta)
            }

            Text(recipe.title)
                .font(PlatedTypography.serifDisplay)
                .foregroundStyle(PlatedColors.deepBrown)

            if let subtitle = recipe.subtitle {
                Text(subtitle)
                    .font(PlatedTypography.serifCallout)
                    .foregroundStyle(PlatedColors.deepBrownSecondary)
            }

            HStack(spacing: PlatedSpacing.xs) {
                Text("By \(recipe.author.name)")
                    .font(PlatedTypography.uiCaption)
                    .foregroundStyle(PlatedColors.deepBrownTertiary)
            }
            .padding(.top, PlatedSpacing.xxs)
        }
        .screenHorizontalPadding()
    }

    private func metadataSection(_ recipe: Recipe) -> some View {
        HStack(spacing: PlatedSpacing.sm) {
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
        VStack(spacing: PlatedSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(PlatedColors.terracotta)

            Text(value)
                .font(PlatedTypography.uiBodyMedium)
                .foregroundStyle(PlatedColors.deepBrown)

            Text(label)
                .font(PlatedTypography.uiCaption2)
                .foregroundStyle(PlatedColors.deepBrownTertiary)
        }
    }

    private func ingredientsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
            Text("Ingredients")
                .font(PlatedTypography.serifTitle3)
                .foregroundStyle(PlatedColors.deepBrown)

            IngredientListView(ingredients: recipe.ingredients)
        }
        .screenHorizontalPadding()
    }

    private func instructionsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
            Text("Instructions")
                .font(PlatedTypography.serifTitle3)
                .foregroundStyle(PlatedColors.deepBrown)

            VStack(alignment: .leading, spacing: PlatedSpacing.lg) {
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                    InstructionStepView(stepNumber: index + 1, instruction: step)
                }
            }
        }
        .screenHorizontalPadding()
    }

    private func nutritionSection(_ nutrition: NutritionInfo) -> some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
            Text("Nutrition")
                .font(PlatedTypography.serifTitle3)
                .foregroundStyle(PlatedColors.deepBrown)

            NutritionBadge(nutrition: nutrition)
        }
        .screenHorizontalPadding()
    }

    private var relatedSection: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
            SectionHeader(title: "You Might Also Like")
                .screenHorizontalPadding()

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: PlatedSpacing.md) {
                    ForEach(viewModel.relatedRecipes) { recipe in
                        NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, PlatedSpacing.screenHorizontal)
            }
        }
    }
}
