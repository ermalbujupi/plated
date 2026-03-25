import SwiftUI

@Observable
final class SavedViewModel {
    private(set) var savedItems: [SavedItem] = []
    private(set) var recipes: [Recipe] = []
    private(set) var editorials: [Editorial] = []
    private(set) var collections: [FoodCollection] = []
    private(set) var isLoading = false
    var selectedFilter: SavedItem.ContentType? = nil

    private let savedItemRepository: any SavedItemRepository
    private let recipeRepository: any RecipeRepository
    private let editorialRepository: any EditorialRepository
    private let collectionRepository: any CollectionRepository

    init(savedItemRepository: any SavedItemRepository, recipeRepository: any RecipeRepository, editorialRepository: any EditorialRepository, collectionRepository: any CollectionRepository) {
        self.savedItemRepository = savedItemRepository
        self.recipeRepository = recipeRepository
        self.editorialRepository = editorialRepository
        self.collectionRepository = collectionRepository
    }

    var filteredItems: [SavedItem] {
        guard let filter = selectedFilter else { return savedItems }
        return savedItems.filter { $0.contentType == filter }
    }

    var isEmpty: Bool {
        filteredItems.isEmpty && !isLoading
    }

    func load() async {
        isLoading = true

        do {
            savedItems = try await savedItemRepository.fetchAll()
            savedItems.sort { $0.savedAt > $1.savedAt }

            // Resolve content
            let allRecipes = try await recipeRepository.fetchAll()
            let allEditorials = try await editorialRepository.fetchAll()
            let allCollections = try await collectionRepository.fetchAll()

            recipes = allRecipes
            editorials = allEditorials
            collections = allCollections
        } catch {}

        isLoading = false
    }

    func recipe(for item: SavedItem) -> Recipe? {
        recipes.first { $0.id == item.contentID }
    }

    func editorial(for item: SavedItem) -> Editorial? {
        editorials.first { $0.id == item.contentID }
    }

    func collection(for item: SavedItem) -> FoodCollection? {
        collections.first { $0.id == item.contentID }
    }

    func remove(_ item: SavedItem) async {
        do {
            try await savedItemRepository.remove(contentID: item.contentID)
            savedItems.removeAll { $0.id == item.id }
        } catch {}
    }
}
