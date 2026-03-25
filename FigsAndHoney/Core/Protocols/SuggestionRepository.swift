import Foundation

protocol SuggestionRepository: Sendable {
    func fetchAll() async throws -> [Suggestion]
    func fetchByCategory(_ category: Suggestion.SuggestionCategory) async throws -> [Suggestion]
}
