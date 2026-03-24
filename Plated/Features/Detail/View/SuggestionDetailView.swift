import SwiftUI

struct SuggestionDetailView: View {
    @Bindable var viewModel: SuggestionDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let suggestion = viewModel.suggestion {
                VStack(alignment: .leading, spacing: PlatedSpacing.xl) {
                    CachedAsyncImage(url: suggestion.imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.card, style: .continuous))
                    .screenHorizontalPadding()

                    VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
                        Text(suggestion.category.displayName.uppercased())
                            .font(PlatedTypography.overline)
                            .tracking(1.5)
                            .foregroundStyle(PlatedColors.terracotta)

                        Text(suggestion.title)
                            .font(PlatedTypography.serifDisplay)
                            .foregroundStyle(PlatedColors.deepBrown)

                        Text(suggestion.prompt)
                            .font(PlatedTypography.serifBody)
                            .foregroundStyle(PlatedColors.deepBrownSecondary)
                            .lineSpacing(5)
                    }
                    .screenHorizontalPadding()

                    if let recipe = viewModel.linkedRecipe {
                        ContentDivider()

                        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
                            SectionHeader(title: "Try This Recipe")
                                .screenHorizontalPadding()

                            NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                                HStack(spacing: PlatedSpacing.md) {
                                    CachedAsyncImage(url: recipe.thumbnailURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    }
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.image, style: .continuous))

                                    VStack(alignment: .leading, spacing: PlatedSpacing.xxs) {
                                        Text(recipe.title)
                                            .font(PlatedTypography.serifHeadline)
                                            .foregroundStyle(PlatedColors.deepBrown)
                                            .lineLimit(2)

                                        Text(recipe.formattedTotalTime)
                                            .font(PlatedTypography.uiCaption)
                                            .foregroundStyle(PlatedColors.deepBrownTertiary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                                }
                            }
                            .buttonStyle(.plain)
                            .screenHorizontalPadding()
                        }
                    }
                }
                .padding(.top, PlatedSpacing.md)
                .padding(.bottom, PlatedSpacing.xxxxl)
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
}
