import SwiftUI

@Observable
final class OnboardingViewModel {
    var currentPage = 0
    var selectedDietary: Set<UserPreferences.DietaryRestriction> = []
    var selectedCuisines: Set<String> = []
    var selectedMoods: Set<UserPreferences.FoodMood> = []
    var selectedMeals: Set<UserPreferences.MealInterest> = []

    let totalPages = 4

    private let preferencesRepository: any UserPreferencesRepository

    init(preferencesRepository: any UserPreferencesRepository) {
        self.preferencesRepository = preferencesRepository
    }

    var canProceed: Bool {
        switch currentPage {
        case 0: return true // Welcome page
        case 1: return true // Dietary is optional
        case 2: return !selectedCuisines.isEmpty
        case 3: return true // Completion
        default: return true
        }
    }

    var isLastPage: Bool {
        currentPage == totalPages - 1
    }

    func nextPage() {
        guard currentPage < totalPages - 1 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage += 1
        }
    }

    func previousPage() {
        guard currentPage > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage -= 1
        }
    }

    func toggleDietary(_ restriction: UserPreferences.DietaryRestriction) {
        if selectedDietary.contains(restriction) {
            selectedDietary.remove(restriction)
        } else {
            selectedDietary.insert(restriction)
        }
    }

    func toggleCuisine(_ cuisine: String) {
        if selectedCuisines.contains(cuisine) {
            selectedCuisines.remove(cuisine)
        } else {
            selectedCuisines.insert(cuisine)
        }
    }

    func toggleMood(_ mood: UserPreferences.FoodMood) {
        if selectedMoods.contains(mood) {
            selectedMoods.remove(mood)
        } else {
            selectedMoods.insert(mood)
        }
    }

    func complete() async {
        let preferences = UserPreferences(
            dietaryRestrictions: selectedDietary,
            favoriteCuisines: selectedCuisines,
            mealInterests: selectedMeals,
            moods: selectedMoods,
            skillLevel: .intermediate,
            hasCompletedOnboarding: true
        )

        do {
            try await preferencesRepository.save(preferences)
        } catch {}
    }
}
