import SwiftUI

@Observable
final class HomeFeedViewModel {
    private(set) var sections: [HomeFeedSection] = []
    private(set) var isLoading = false
    private(set) var error: Error?

    private let homeFeedRepository: any HomeFeedRepository
    private let savedItemRepository: any SavedItemRepository

    init(homeFeedRepository: any HomeFeedRepository, savedItemRepository: any SavedItemRepository) {
        self.homeFeedRepository = homeFeedRepository
        self.savedItemRepository = savedItemRepository
    }

    func loadFeed() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        do {
            sections = try await homeFeedRepository.fetchFeed()
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func refresh() async {
        error = nil
        do {
            sections = try await homeFeedRepository.fetchFeed()
        } catch {
            self.error = error
        }
    }
}
