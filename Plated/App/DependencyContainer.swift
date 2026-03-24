import SwiftUI

@Observable
final class DependencyContainer {
    let recipeRepository: any RecipeRepository
    let editorialRepository: any EditorialRepository
    let suggestionRepository: any SuggestionRepository
    let collectionRepository: any CollectionRepository
    let savedItemRepository: any SavedItemRepository
    let userPreferencesRepository: any UserPreferencesRepository
    let homeFeedRepository: any HomeFeedRepository

    init() {
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
