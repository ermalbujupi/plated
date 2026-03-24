import SwiftUI

struct SavedView: View {
    @Bindable var viewModel: SavedViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: PlatedSpacing.lg) {
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: PlatedSpacing.xs) {
                        FilterChip(title: "All", isSelected: viewModel.selectedFilter == nil) {
                            viewModel.selectedFilter = nil
                        }

                        FilterChip(title: "Recipes", isSelected: viewModel.selectedFilter == .recipe) {
                            viewModel.selectedFilter = .recipe
                        }

                        FilterChip(title: "Stories", isSelected: viewModel.selectedFilter == .editorial) {
                            viewModel.selectedFilter = .editorial
                        }

                        FilterChip(title: "Collections", isSelected: viewModel.selectedFilter == .collection) {
                            viewModel.selectedFilter = .collection
                        }
                    }
                    .padding(.horizontal, PlatedSpacing.screenHorizontal)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if viewModel.isEmpty {
                    EmptyStateView()
                } else {
                    // Saved items list
                    VStack(spacing: 0) {
                        ForEach(viewModel.filteredItems) { item in
                            let route = routeFor(item)

                            if let route {
                                NavigationLink(value: route) {
                                    SavedItemRow(
                                        item: item,
                                        recipe: viewModel.recipe(for: item),
                                        editorial: viewModel.editorial(for: item),
                                        collection: viewModel.collection(for: item)
                                    )
                                }
                                .buttonStyle(.plain)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        Task { await viewModel.remove(item) }
                                    } label: {
                                        Label("Remove", systemImage: "bookmark.slash")
                                    }
                                    .tint(PlatedColors.terracotta)
                                }
                            }

                            if item.id != viewModel.filteredItems.last?.id {
                                ContentDivider()
                                    .padding(.vertical, PlatedSpacing.xs)
                            }
                        }
                    }
                    .screenHorizontalPadding()
                }
            }
            .padding(.vertical, PlatedSpacing.lg)
        }
        .background(PlatedColors.cream)
        .navigationTitle("Saved")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.load()
        }
    }

    private func routeFor(_ item: SavedItem) -> Route? {
        switch item.contentType {
        case .recipe: return .recipeDetail(id: item.contentID)
        case .editorial: return .editorialDetail(id: item.contentID)
        case .collection: return .collectionDetail(id: item.contentID)
        case .suggestion: return .suggestionDetail(id: item.contentID)
        }
    }
}
