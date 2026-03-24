import Foundation

protocol HomeFeedRepository: Sendable {
    func fetchFeed() async throws -> [HomeFeedSection]
}
