import UIKit

actor ImagePipeline {
    static let shared = ImagePipeline()

    private let session: URLSession
    private var activeTasks: [URL: Task<UIImage, Error>] = [:]

    private init() {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024)
        config.httpMaximumConnectionsPerHost = 6
        self.session = URLSession(configuration: config)
    }

    func image(for url: URL) async throws -> UIImage {
        // Check cache first
        if let cached = await ImageCache.shared.image(for: url) {
            return cached
        }

        // Deduplicate concurrent requests for the same URL
        if let existingTask = activeTasks[url] {
            return try await existingTask.value
        }

        let task = Task<UIImage, Error> {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw ImagePipelineError.invalidResponse
            }

            guard let image = UIImage(data: data) else {
                throw ImagePipelineError.decodingFailed
            }

            await ImageCache.shared.store(image, for: url)
            return image
        }

        activeTasks[url] = task

        do {
            let image = try await task.value
            activeTasks[url] = nil
            return image
        } catch {
            activeTasks[url] = nil
            throw error
        }
    }
}

enum ImagePipelineError: LocalizedError {
    case invalidResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid server response"
        case .decodingFailed: return "Failed to decode image data"
        }
    }
}
