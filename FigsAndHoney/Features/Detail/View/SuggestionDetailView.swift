import SwiftUI

struct SuggestionDetailView: View {
    @Bindable var viewModel: SuggestionDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let suggestion = viewModel.suggestion {
                VStack(alignment: .leading, spacing: FHSpacing.xl) {
                    CachedAsyncImage(url: suggestion.imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: FHRadius.card, style: .continuous))
                    .screenHorizontalPadding()

                    VStack(alignment: .leading, spacing: FHSpacing.sm) {
                        Text(suggestion.category.displayName.uppercased())
                            .font(FHTypography.overline)
                            .tracking(1.5)
                            .foregroundStyle(FHColors.terracotta)

                        Text(suggestion.title)
                            .font(FHTypography.serifDisplay)
                            .foregroundStyle(FHColors.deepBrown)

                        Text(suggestion.prompt)
                            .font(FHTypography.serifBody)
                            .foregroundStyle(FHColors.deepBrownSecondary)
                            .lineSpacing(5)
                    }
                    .screenHorizontalPadding()

                    if let recipe = viewModel.linkedRecipe {
                        ContentDivider()

                        VStack(alignment: .leading, spacing: FHSpacing.md) {
                            SectionHeader(title: "Try This Recipe")
                                .screenHorizontalPadding()

                            NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                                HStack(spacing: FHSpacing.md) {
                                    CachedAsyncImage(url: recipe.thumbnailURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    }
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: FHRadius.image, style: .continuous))

                                    VStack(alignment: .leading, spacing: FHSpacing.xxs) {
                                        Text(recipe.title)
                                            .font(FHTypography.serifHeadline)
                                            .foregroundStyle(FHColors.deepBrown)
                                            .lineLimit(2)

                                        Text(recipe.formattedTotalTime)
                                            .font(FHTypography.uiCaption)
                                            .foregroundStyle(FHColors.deepBrownTertiary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(FHColors.deepBrownTertiary)
                                }
                            }
                            .buttonStyle(.plain)
                            .screenHorizontalPadding()
                        }
                    }
                }
                .padding(.top, FHSpacing.md)
                .padding(.bottom, FHSpacing.xxxxl)
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
}
