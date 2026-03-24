import SwiftUI

@Observable
final class RecipeDetailViewModel {
    private(set) var recipe: Recipe?
    private(set) var relatedRecipes: [Recipe] = []
    private(set) var isSaved = false
    private(set) var isLoading = false

    let recipeID: String
    private let recipeRepository: any RecipeRepository
    private let savedItemRepository: any SavedItemRepository

    init(recipeID: String, recipeRepository: any RecipeRepository, savedItemRepository: any SavedItemRepository) {
        self.recipeID = recipeID
        self.recipeRepository = recipeRepository
        self.savedItemRepository = savedItemRepository
    }

    func load() async {
        isLoading = true

        do {
            recipe = try await recipeRepository.fetchByID(recipeID)
            isSaved = try await savedItemRepository.isSaved(contentID: recipeID)

            if let recipe, !recipe.relatedRecipeIDs.isEmpty {
                let allRecipes = try await recipeRepository.fetchAll()
                relatedRecipes = allRecipes.filter { recipe.relatedRecipeIDs.contains($0.id) }
            }
        } catch {
            // Handle silently for now
        }

        isLoading = false
    }

    func toggleSave() async {
        guard let recipe else { return }

        do {
            if isSaved {
                try await savedItemRepository.remove(contentID: recipe.id)
            } else {
                let item = SavedItem(contentType: .recipe, contentID: recipe.id)
                try await savedItemRepository.save(item)
            }
            isSaved.toggle()
        } catch {
            // Handle silently
        }
    }
}
