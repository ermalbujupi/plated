import SwiftUI

@Observable
final class CollectionDetailViewModel {
    private(set) var collection: FoodCollection?
    private(set) var recipes: [Recipe] = []
    private(set) var isSaved = false
    private(set) var isLoading = false

    let collectionID: String
    private let collectionRepository: any CollectionRepository
    private let recipeRepository: any RecipeRepository
    private let savedItemRepository: any SavedItemRepository

    init(collectionID: String, collectionRepository: any CollectionRepository, recipeRepository: any RecipeRepository, savedItemRepository: any SavedItemRepository) {
        self.collectionID = collectionID
        self.collectionRepository = collectionRepository
        self.recipeRepository = recipeRepository
        self.savedItemRepository = savedItemRepository
    }

    func load() async {
        isLoading = true

        do {
            collection = try await collectionRepository.fetchByID(collectionID)
            isSaved = try await savedItemRepository.isSaved(contentID: collectionID)

            if let collection {
                let allRecipes = try await recipeRepository.fetchAll()
                recipes = allRecipes.filter { collection.recipeIDs.contains($0.id) }
            }
        } catch {}

        isLoading = false
    }

    func toggleSave() async {
        guard let collection else { return }

        do {
            if isSaved {
                try await savedItemRepository.remove(contentID: collection.id)
            } else {
                let item = SavedItem(contentType: .collection, contentID: collection.id)
                try await savedItemRepository.save(item)
            }
            isSaved.toggle()
        } catch {}
    }
}
