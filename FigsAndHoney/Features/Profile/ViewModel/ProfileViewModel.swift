import SwiftUI

@Observable
final class ProfileViewModel {
    private(set) var preferences: UserPreferences = .default
    private(set) var isLoading = false

    private let preferencesRepository: any UserPreferencesRepository

    init(preferencesRepository: any UserPreferencesRepository) {
        self.preferencesRepository = preferencesRepository
    }

    func load() async {
        isLoading = true
        do {
            preferences = try await preferencesRepository.fetch()
        } catch {}
        isLoading = false
    }

    func toggleDietary(_ restriction: UserPreferences.DietaryRestriction) async {
        if preferences.dietaryRestrictions.contains(restriction) {
            preferences.dietaryRestrictions.remove(restriction)
        } else {
            preferences.dietaryRestrictions.insert(restriction)
        }
        await savePreferences()
    }

    func toggleCuisine(_ cuisine: String) async {
        if preferences.favoriteCuisines.contains(cuisine) {
            preferences.favoriteCuisines.remove(cuisine)
        } else {
            preferences.favoriteCuisines.insert(cuisine)
        }
        await savePreferences()
    }

    func setSkillLevel(_ level: UserPreferences.SkillLevel) async {
        preferences.skillLevel = level
        await savePreferences()
    }

    private func savePreferences() async {
        do {
            try await preferencesRepository.save(preferences)
        } catch {}
    }
}
