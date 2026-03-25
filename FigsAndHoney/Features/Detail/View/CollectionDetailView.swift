import SwiftUI

struct CollectionDetailView: View {
    @Bindable var viewModel: CollectionDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let collection = viewModel.collection {
                VStack(alignment: .leading, spacing: FHSpacing.xl) {
                    // Hero
                    HeroHeaderView(imageURL: collection.coverImageURL, height: 300)

                    // Header
                    VStack(alignment: .leading, spacing: FHSpacing.xs) {
                        Text(collection.title)
                            .font(FHTypography.serifDisplay)
                            .foregroundStyle(FHColors.deepBrown)

                        if let subtitle = collection.subtitle {
                            Text(subtitle)
                                .font(FHTypography.serifCallout)
                                .foregroundStyle(FHColors.deepBrownSecondary)
                        }

                        Text(collection.description)
                            .font(FHTypography.serifBody)
                            .foregroundStyle(FHColors.deepBrownSecondary)
                            .lineSpacing(5)
                            .padding(.top, FHSpacing.xs)

                        if let curator = collection.curatedBy {
                            Text("Curated by \(curator.name)")
                                .font(FHTypography.uiCaption)
                                .foregroundStyle(FHColors.deepBrownTertiary)
                                .padding(.top, FHSpacing.xxs)
                        }
                    }
                    .screenHorizontalPadding()

                    ContentDivider()

                    // Recipe list
                    VStack(alignment: .leading, spacing: FHSpacing.md) {
                        Text("\(viewModel.recipes.count) Recipes")
                            .font(FHTypography.serifTitle3)
                            .foregroundStyle(FHColors.deepBrown)
                            .screenHorizontalPadding()

                        ForEach(viewModel.recipes) { recipe in
                            NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                                HStack(spacing: FHSpacing.md) {
                                    CachedAsyncImage(url: recipe.thumbnailURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    }
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: FHRadius.image, style: .continuous))

                                    VStack(alignment: .leading, spacing: FHSpacing.xxs) {
                                        Text(recipe.title)
                                            .font(FHTypography.serifHeadline)
                                            .foregroundStyle(FHColors.deepBrown)
                                            .lineLimit(2)

                                        HStack(spacing: FHSpacing.xs) {
                                            Text(recipe.formattedTotalTime)
                                            Text("\u{00B7}")
                                            Text(recipe.difficulty.displayName)
                                        }
                                        .font(FHTypography.uiCaption)
                                        .foregroundStyle(FHColors.deepBrownTertiary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(FHColors.deepBrownTertiary)
                                }
                            }
                            .buttonStyle(.plain)
                            .screenHorizontalPadding()

                            if recipe.id != viewModel.recipes.last?.id {
                                ContentDivider()
                            }
                        }
                    }
                }
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
