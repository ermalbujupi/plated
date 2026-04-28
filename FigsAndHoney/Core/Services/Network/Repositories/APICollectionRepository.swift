import Foundation

struct APICollectionRepository: CollectionRepository {
    let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchAll() async throws -> [FoodCollection] {
        let dtos: [CollectionDTO] = try await client.get(
            "collections",
            query: ["perPage": "50"]
        )
        return dtos.map { $0.toModel() }
    }

    func fetchByID(_ id: String) async throws -> FoodCollection? {
        do {
            let dto: CollectionDTO = try await client.get("collections/\(id)")
            return dto.toModel()
        } catch let APIError.server(_, code, _) where code == "NOT_FOUND" {
            return nil
        }
    }
}
