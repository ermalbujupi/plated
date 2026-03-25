import UIKit

actor ImageCache {
    static let shared = ImageCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default

    private var cacheDirectory: URL {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("FigsAndHoneyImages", isDirectory: true)
    }

    private init() {
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50MB
        ensureCacheDirectory()
    }

    private nonisolated func ensureCacheDirectory() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let dir = paths[0].appendingPathComponent("FigsAndHoneyImages", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
    }

    func image(for url: URL) -> UIImage? {
        let key = cacheKey(for: url)

        // Check memory cache
        if let cached = memoryCache.object(forKey: key as NSString) {
            return cached
        }

        // Check disk cache
        let filePath = diskPath(for: key)
        if let data = try? Data(contentsOf: filePath),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key as NSString, cost: data.count)
            return image
        }

        return nil
    }

    func store(_ image: UIImage, for url: URL) {
        let key = cacheKey(for: url)
        let data = image.jpegData(compressionQuality: 0.8)
        let cost = data?.count ?? 0

        // Store in memory
        memoryCache.setObject(image, forKey: key as NSString, cost: cost)

        // Store on disk
        if let data {
            let filePath = diskPath(for: key)
            try? data.write(to: filePath)
        }
    }

    func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }

    private func cacheKey(for url: URL) -> String {
        url.absoluteString.data(using: .utf8)!
            .base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
    }

    private func diskPath(for key: String) -> URL {
        cacheDirectory.appendingPathComponent(key)
    }
}
