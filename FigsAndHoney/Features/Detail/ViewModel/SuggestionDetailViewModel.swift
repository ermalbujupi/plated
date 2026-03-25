import SwiftUI

@Observable
final class SuggestionDetailViewModel {
    private(set) var suggestion: Suggestion?
    private(set) var linkedRecipe: Recipe?
    private(set) var isSaved = false
    private(set) var isLoading = false

    let suggestionID: String
    private let suggestionRepository: any SuggestionRepository
    private let recipeRepository: any RecipeRepository
    private let savedItemRepository: any SavedItemRepository

    init(suggestionID: String, suggestionRepository: any SuggestionRepository, recipeRepository: any RecipeRepository, savedItemRepository: any SavedItemRepository) {
        self.suggestionID = suggestionID
        self.suggestionRepository = suggestionRepository
        self.recipeRepository = recipeRepository
        self.savedItemRepository = savedItemRepository
    }

    func load() async {
        isLoading = true

        do {
            let all = try await suggestionRepository.fetchAll()
            suggestion = all.first { $0.id == suggestionID }
            isSaved = try await savedItemRepository.isSaved(contentID: suggestionID)

            if let recipeID = suggestion?.linkedRecipeID {
                linkedRecipe = try await recipeRepository.fetchByID(recipeID)
            }
        } catch {}

        isLoading = false
    }

    func toggleSave() async {
        guard let suggestion else { return }

        do {
            if isSaved {
                try await savedItemRepository.remove(contentID: suggestion.id)
            } else {
                let item = SavedItem(contentType: .suggestion, contentID: suggestion.id)
                try await savedItemRepository.save(item)
            }
            isSaved.toggle()
        } catch {}
    }
}
