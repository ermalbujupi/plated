import SwiftUI

struct AppTabView: View {
    @Bindable var router: Router
    @Bindable var appState: AppState
    let container: DependencyContainer

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack(path: $router.homePath) {
                HomeTabRoot(container: container)
                    .navigationDestinations(container: container)
            }
            .tabItem {
                Label("Home", systemImage: AppTab.home.systemImage)
            }
            .tag(AppTab.home)

            NavigationStack(path: $router.explorePath) {
                ExploreTabRoot(container: container)
                    .navigationDestinations(container: container)
            }
            .tabItem {
                Label("Explore", systemImage: AppTab.explore.systemImage)
            }
            .tag(AppTab.explore)

            NavigationStack(path: $router.savedPath) {
                SavedTabRoot(container: container)
                    .navigationDestinations(container: container)
            }
            .tabItem {
                Label("Saved", systemImage: AppTab.saved.systemImage)
            }
            .tag(AppTab.saved)

            NavigationStack(path: $router.profilePath) {
                ProfileTabRoot(container: container)
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

// MARK: - Tab roots
//
// Each tab gets its own root view that owns its ViewModel via `@State`. Without
// this layer, the ViewModels were being constructed inline in `AppTabView.body`,
// so any re-render (e.g. after a navigation push/pop) created a fresh empty VM
// — wiping loaded state and cancelling in-flight requests.

private struct HomeTabRoot: View {
    let container: DependencyContainer
    @State private var viewModel: HomeFeedViewModel

    init(container: DependencyContainer) {
        self.container = container
        _viewModel = State(initialValue: HomeFeedViewModel(
            homeFeedRepository: container.homeFeedRepository,
            savedItemRepository: container.savedItemRepository
        ))
    }

    var body: some View {
        HomeFeedView(viewModel: viewModel)
    }
}

private struct ExploreTabRoot: View {
    let container: DependencyContainer
    @State private var viewModel: ExploreViewModel

    init(container: DependencyContainer) {
        self.container = container
        _viewModel = State(initialValue: ExploreViewModel(
            recipeRepository: container.recipeRepository,
            editorialRepository: container.editorialRepository,
            collectionRepository: container.collectionRepository
        ))
    }

    var body: some View {
        ExploreView(viewModel: viewModel)
    }
}

private struct SavedTabRoot: View {
    let container: DependencyContainer
    @State private var viewModel: SavedViewModel

    init(container: DependencyContainer) {
        self.container = container
        _viewModel = State(initialValue: SavedViewModel(
            savedItemRepository: container.savedItemRepository,
            recipeRepository: container.recipeRepository,
            editorialRepository: container.editorialRepository,
            collectionRepository: container.collectionRepository
        ))
    }

    var body: some View {
        SavedView(viewModel: viewModel)
    }
}

private struct ProfileTabRoot: View {
    let container: DependencyContainer
    @State private var viewModel: ProfileViewModel

    init(container: DependencyContainer) {
        self.container = container
        _viewModel = State(initialValue: ProfileViewModel(
            preferencesRepository: container.userPreferencesRepository
        ))
    }

    var body: some View {
        ProfileView(viewModel: viewModel)
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
