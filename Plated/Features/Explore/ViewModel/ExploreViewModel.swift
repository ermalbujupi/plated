import SwiftUI

@Observable
final class ExploreViewModel {
    var searchQuery = ""
    private(set) var searchResults: [Recipe] = []
    private(set) var editorialResults: [Editorial] = []
    private(set) var featuredCollections: [FoodCollection] = []
    private(set) var trendingRecipes: [Recipe] = []
    private(set) var isSearching = false
    private(set) var isLoading = false

    private let recipeRepository: any RecipeRepository
    private let editorialRepository: any EditorialRepository
    private let collectionRepository: any CollectionRepository

    init(recipeRepository: any RecipeRepository, editorialRepository: any EditorialRepository, collectionRepository: any CollectionRepository) {
        self.recipeRepository = recipeRepository
        self.editorialRepository = editorialRepository
        self.collectionRepository = collectionRepository
    }

    var isShowingResults: Bool {
        !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func loadInitialContent() async {
        guard !isLoading else { return }
        isLoading = true

        do {
            async let recipesTask = recipeRepository.fetchFeatured()
            async let collectionsTask = collectionRepository.fetchAll()

            trendingRecipes = try await recipesTask
            featuredCollections = try await collectionsTask
        } catch {}

        isLoading = false
    }

    func search() async {
        let query = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            searchResults = []
            editorialResults = []
            return
        }

        isSearching = true

        do {
            async let recipesTask = recipeRepository.search(query: query)
            async let editorialsTask = editorialRepository.search(query: query)

            searchResults = try await recipesTask
            editorialResults = try await editorialsTask
        } catch {}

        isSearching = false
    }

    func searchByCategory(_ category: ExploreCategory) async {
        searchQuery = category.rawValue
        await search()
    }
}
