import Foundation

actor LocalPreferencesRepository: UserPreferencesRepository {
    private let key = "plated_user_preferences"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func fetch() async throws -> UserPreferences {
        guard let data = defaults.data(forKey: key) else {
            return .default
        }
        return try JSONDecoder().decode(UserPreferences.self, from: data)
    }

    func save(_ preferences: UserPreferences) async throws {
        let data = try JSONEncoder().encode(preferences)
        defaults.set(data, forKey: key)
    }
}
