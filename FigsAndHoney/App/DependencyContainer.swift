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

    init() {
        self.authService = AuthService()

        // Content repositories — still mocked. Stage 3 will swap these for API-backed
        // implementations one at a time. Persistence repos stay local for now.
        let loader = MockDataLoader()
        self.recipeRepository = MockRecipeRepository(loader: loader)
        self.editorialRepository = MockEditorialRepository(loader: loader)
        self.suggestionRepository = MockSuggestionRepository(loader: loader)
        self.collectionRepository = MockCollectionRepository(loader: loader)
        self.savedItemRepository = LocalSavedItemRepository()
        self.userPreferencesRepository = LocalPreferencesRepository()
        self.homeFeedRepository = MockHomeFeedRepository(loader: loader)
    }
}
