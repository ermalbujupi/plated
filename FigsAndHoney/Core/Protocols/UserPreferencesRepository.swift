import Foundation

protocol UserPreferencesRepository: Sendable {
    func fetch() async throws -> UserPreferences
    func save(_ preferences: UserPreferences) async throws
}
