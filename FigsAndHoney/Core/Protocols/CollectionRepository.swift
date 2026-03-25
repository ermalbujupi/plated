import Foundation

protocol CollectionRepository: Sendable {
    func fetchAll() async throws -> [FoodCollection]
    func fetchByID(_ id: String) async throws -> FoodCollection?
}
