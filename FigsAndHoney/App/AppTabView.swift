import SwiftUI

struct AppTabView: View {
    @Bindable var router: Router
    @Bindable var appState: AppState
    let container: DependencyContainer

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack(path: $router.homePath) {
                HomeFeedView(
                    viewModel: HomeFeedViewModel(
                        homeFeedRepository: container.homeFeedRepository,
                        savedItemRepository: container.savedItemRepository
                    )
                )
                .navigationDestinations(container: container)
            }
            .tabItem {
                Label("Home", systemImage: AppTab.home.systemImage)
            }
            .tag(AppTab.home)

            NavigationStack(path: $router.explorePath) {
                ExploreView(
                    viewModel: ExploreViewModel(
                        recipeRepository: container.recipeRepository,
                        editorialRepository: container.editorialRepository,
                        collectionRepository: container.collectionRepository
                    )
                )
                .navigationDestinations(container: container)
            }
            .tabItem {
                Label("Explore", systemImage: AppTab.explore.systemImage)
            }
            .tag(AppTab.explore)

            NavigationStack(path: $router.savedPath) {
                SavedView(
                    viewModel: SavedViewModel(
                        savedItemRepository: container.savedItemRepository,
                        recipeRepository: container.recipeRepository,
                        editorialRepository: container.editorialRepository,
                        collectionRepository: container.collectionRepository
                    )
                )
                .navigationDestinations(container: container)
            }
            .tabItem {
                Label("Saved", systemImage: AppTab.saved.systemImage)
            }
            .tag(AppTab.saved)

            NavigationStack(path: $router.profilePath) {
                ProfileView(
                    viewModel: ProfileViewModel(
                        preferencesRepository: container.userPreferencesRepository
                    )
                )
                .navigationDestinations(container: container)
            }
            .tabItem {
                Label("Profile", systemImage: AppTab.profile.systemImage)
            }
            .tag(AppTab.profile)
        }
        .tint(FHColors.terracotta)
    }
}

// MARK: - Navigation Destinations

private struct NavigationDestinationsModifier: ViewModifier {
    let container: DependencyContainer

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .recipeDetail(let id):
                    RecipeDetailView(
                        viewModel: RecipeDetailViewModel(
                            recipeID: id,
                            recipeRepository: container.recipeRepository,
                            savedItemRepository: container.savedItemRepository
                        )
                    )
                case .editorialDetail(let id):
                    EditorialDetailView(
                        viewModel: EditorialDetailViewModel(
                            editorialID: id,
                            editorialRepository: container.editorialRepository,
                            recipeRepository: container.recipeRepository,
                            savedItemRepository: container.savedItemRepository
                        )
                    )
                case .suggestionDetail(let id):
                    SuggestionDetailView(
                        viewModel: SuggestionDetailViewModel(
                            suggestionID: id,
                            suggestionRepository: container.suggestionRepository,
                            recipeRepository: container.recipeRepository,
                            savedItemRepository: container.savedItemRepository
                        )
                    )
                case .collectionDetail(let id):
                    CollectionDetailView(
                        viewModel: CollectionDetailViewModel(
                            collectionID: id,
                            collectionRepository: container.collectionRepository,
                            recipeRepository: container.recipeRepository,
                            savedItemRepository: container.savedItemRepository
                        )
                    )
                case .search:
                    ExploreView(
                        viewModel: ExploreViewModel(
                            recipeRepository: container.recipeRepository,
                            editorialRepository: container.editorialRepository,
                            collectionRepository: container.collectionRepository
                        )
                    )
                }
            }
    }
}

extension View {
    func navigationDestinations(container: DependencyContainer) -> some View {
        modifier(NavigationDestinationsModifier(container: container))
    }
}
