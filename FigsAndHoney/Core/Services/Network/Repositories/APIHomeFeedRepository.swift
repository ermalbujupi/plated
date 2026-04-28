import Foundation

struct APIHomeFeedRepository: HomeFeedRepository {
    let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchFeed() async throws -> [HomeFeedSection] {
        let response: FeedResponseDTO = try await client.get("feed/home")
        return response.toModel()
    }
}
