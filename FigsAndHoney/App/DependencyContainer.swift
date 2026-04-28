import SwiftUI

@Observable
@MainActor
final class DependencyContainer {
    let authService: AuthService

    let recipeRepository: any RecipeRepository
    let editorialRepository: any EditorialRepository
    let suggestionRepository: any SuggestionRepository
    let collectionRepository: any CollectionRepository
    let savedItemRepository: any SavedItemRepository
    let userPreferencesRepository: any UserPreferencesRepository
    let homeFeedRepository: any HomeFeedRepository

    /// Per-repo source toggles. Flip individual flags to swap mock data for
    /// real API calls. Useful while we validate each endpoint end-to-end.
    /// Once everything's stable, just delete the mocks and inline the API repos.
    struct Sources {
        var recipes:    Source = .api
        var editorials: Source = .api
        var collections: Source = .api
        var suggestions: Source = .api
        var homeFeed:    Source = .api

        enum Source { case mock, api }
    }

    init(sources: Sources = Sources()) {
        self.authService = AuthService()

        let loader = MockDataLoader()
        self.recipeRepository = sources.recipes == .api
            ? APIRecipeRepository()
            : MockRecipeRepository(loader: loader)
        self.editorialRepository = sources.editorials == .api
            ? APIEditorialRepository()
            : MockEditorialRepository(loader: loader)
        self.suggestionRepository = sources.suggestions == .api
            ? APISuggestionRepository()
            : MockSuggestionRepository(loader: loader)
        self.collectionRepository = sources.collections == .api
            ? APICollectionRepository()
            : MockCollectionRepository(loader: loader)
        self.homeFeedRepository = sources.homeFeed == .api
            ? APIHomeFeedRepository()
            : MockHomeFeedRepository(loader: loader)

        // User-data repos stay local for now. Stage 4 will add API versions
        // backed by /user/preferences and /user/saved.
        self.savedItemRepository = LocalSavedItemRepository()
        self.userPreferencesRepository = LocalPreferencesRepository()
    }
}
