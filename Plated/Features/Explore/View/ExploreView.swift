import SwiftUI

struct ExploreView: View {
    @Bindable var viewModel: ExploreViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.isShowingResults {
                searchResultsContent
            } else {
                browseContent
            }
        }
        .background(PlatedColors.cream)
        .searchable(
            text: $viewModel.searchQuery,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search recipes, editorials..."
        )
        .onChange(of: viewModel.searchQuery) { _, _ in
            Task { await viewModel.search() }
        }
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.large)
        .task {
            if viewModel.trendingRecipes.isEmpty {
                await viewModel.loadInitialContent()
            }
        }
    }

    private var browseContent: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.sectionSpacing) {
            // Categories
            VStack(alignment: .leading, spacing: PlatedSpacing.md) {
                SectionHeader(title: "Browse by Category")
                CategoryGrid { category in
                    Task { await viewModel.searchByCategory(category) }
                }
            }
            .screenHorizontalPadding()

            // Trending
            if !viewModel.trendingRecipes.isEmpty {
                TrendingSection(recipes: viewModel.trendingRecipes)
                    .screenHorizontalPadding()
            }

            // Collections
            if !viewModel.featuredCollections.isEmpty {
                VStack(alignment: .leading, spacing: PlatedSpacing.md) {
                    SectionHeader(title: "Collections")
                        .screenHorizontalPadding()

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: PlatedSpacing.md) {
                            ForEach(viewModel.featuredCollections) { collection in
                                NavigationLink(value: Route.collectionDetail(id: collection.id)) {
                                    CollectionCard(collection: collection)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, PlatedSpacing.screenHorizontal)
                    }
                }
            }
        }
        .padding(.vertical, PlatedSpacing.lg)
    }

    private var searchResultsContent: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.lg) {
            if viewModel.isSearching {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 200)
            } else if viewModel.searchResults.isEmpty && viewModel.editorialResults.isEmpty {
                emptySearchState
            } else {
                // Recipe results
                if !viewModel.searchResults.isEmpty {
                    VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
                        Text("Recipes")
                            .font(PlatedTypography.serifTitle3)
                            .foregroundStyle(PlatedColors.deepBrown)

                        ForEach(viewModel.searchResults) { recipe in
                            NavigationLink(value: Route.recipeDetail(id: recipe.id)) {
                                SearchResultRow(recipe: recipe)
                            }
                            .buttonStyle(.plain)

                            if recipe.id != viewModel.searchResults.last?.id {
                                Divider()
                                    .foregroundStyle(PlatedColors.divider)
                            }
                        }
                    }
                }

                // Editorial results
                if !viewModel.editorialResults.isEmpty {
                    VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
                        Text("Stories")
                            .font(PlatedTypography.serifTitle3)
                            .foregroundStyle(PlatedColors.deepBrown)

                        ForEach(viewModel.editorialResults) { editorial in
                            NavigationLink(value: Route.editorialDetail(id: editorial.id)) {
                                EditorialCard(editorial: editorial)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .screenHorizontalPadding()
        .padding(.vertical, PlatedSpacing.lg)
    }

    private var emptySearchState: some View {
        VStack(spacing: PlatedSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(PlatedColors.stone)

            Text("No results found")
                .font(PlatedTypography.serifHeadline)
                .foregroundStyle(PlatedColors.deepBrown)

            Text("Try a different search term")
                .font(PlatedTypography.uiCallout)
                .foregroundStyle(PlatedColors.deepBrownTertiary)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
}
