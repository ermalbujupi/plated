import SwiftUI

@Observable
final class EditorialDetailViewModel {
    private(set) var editorial: Editorial?
    private(set) var relatedRecipes: [Recipe] = []
    private(set) var isSaved = false
    private(set) var isLoading = false

    let editorialID: String
    private let editorialRepository: any EditorialRepository
    private let recipeRepository: any RecipeRepository
    private let savedItemRepository: any SavedItemRepository

    init(editorialID: String, editorialRepository: any EditorialRepository, recipeRepository: any RecipeRepository, savedItemRepository: any SavedItemRepository) {
        self.editorialID = editorialID
        self.editorialRepository = editorialRepository
        self.recipeRepository = recipeRepository
        self.savedItemRepository = savedItemRepository
    }

    func load() async {
        isLoading = true

        do {
            editorial = try await editorialRepository.fetchByID(editorialID)
            isSaved = try await savedItemRepository.isSaved(contentID: editorialID)

            if let editorial, !editorial.relatedRecipeIDs.isEmpty {
                let allRecipes = try await recipeRepository.fetchAll()
                relatedRecipes = allRecipes.filter { editorial.relatedRecipeIDs.contains($0.id) }
            }
        } catch {
            // Handle silently
        }

        isLoading = false
    }

    func toggleSave() async {
        guard let editorial else { return }

        do {
            if isSaved {
                try await savedItemRepository.remove(contentID: editorial.id)
            } else {
                let item = SavedItem(contentType: .editorial, contentID: editorial.id)
                try await savedItemRepository.save(item)
            }
            isSaved.toggle()
        } catch {}
    }
}
