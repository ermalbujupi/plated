import SwiftUI

struct CollectionDetailView: View {
    @Bindable var viewModel: CollectionDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let collection = viewModel.collection {
                VStack(alignment: .leading, spacing: PlatedSpacing.xl) {
                    // Hero
                    HeroHeaderView(imageURL: collection.coverImageURL, height: 300)

                    // Header
                    VStack(alignment: .leading, spacing: PlatedSpacing.xs) {
                        Text(collection.title)
                            .font(PlatedTypography.serifDisplay)
                            .foregroundStyle(PlatedColors.deepBrown)

                        if let subtitle = collection.subtitle {
                            Text(subtitle)
                                .font(PlatedTypography.serifCallout)
                                .foregroundStyle(PlatedColors.deepBrownSecondary)
                        }

                        Text(collection.description)
                            .font(PlatedTypography.serifBody)
                            .foregroundStyle(PlatedColors.deepBrownSecondary)
                            .lineSpacing(5)
                            .padding(.top, PlatedSpacing.xs)

                        if let curator = collection.curatedBy {
                            Text("Curated by \(curator.name)")
                                .font(PlatedTypography.uiCaption)
                                .foregroundStyle(PlatedColors.deepBrownTertiary)
                                .padding(.top, PlatedSpacing.xxs)
                        }
                    }
                    .screenHorizontalPadding()

                    ContentDivider()

                    // Recipe list
                    VStack(alignment: .leading, spacing: PlatedSpacing.md) {
                        Text("\(viewModel.recipes.count) Recipes")
                            .font(PlatedTypography.serifTitle3)
                            .foregroundStyle(PlatedColors.deepBrown)
                            .screenHorizontalPadding()

                        ForEach(viewModel.recipes) { recipe in
                            NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                                HStack(spacing: PlatedSpacing.md) {
                                    CachedAsyncImage(url: recipe.thumbnailURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    }
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.image, style: .continuous))

                                    VStack(alignment: .leading, spacing: PlatedSpacing.xxs) {
                                        Text(recipe.title)
                                            .font(PlatedTypography.serifHeadline)
                                            .foregroundStyle(PlatedColors.deepBrown)
                                            .lineLimit(2)

                                        HStack(spacing: PlatedSpacing.xs) {
                                            Text(recipe.formattedTotalTime)
                                            Text("\u{00B7}")
                                            Text(recipe.difficulty.displayName)
                                        }
                                        .font(PlatedTypography.uiCaption)
                                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(PlatedColors.deepBrownTertiary)
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
