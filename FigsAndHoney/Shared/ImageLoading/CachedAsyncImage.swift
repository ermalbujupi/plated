import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else if let assetImage = assetCatalogImage {
                content(assetImage)
            } else {
                placeholder()
                    .task(id: url) {
                        await loadImage()
                    }
            }
        }
    }

    /// If the URL uses the `asset://` scheme, load directly from the asset catalog
    private var assetCatalogImage: Image? {
        guard let url, url.scheme == "asset" else { return nil }
        let assetName = url.host() ?? url.absoluteString
            .replacingOccurrences(of: "asset://", with: "")
        guard UIImage(named: assetName) != nil else { return nil }
        return Image(assetName)
    }

    private func loadImage() async {
        guard let url, url.scheme != "asset", !isLoading else { return }
        isLoading = true

        do {
            let loadedImage = try await ImagePipeline.shared.image(for: url)
            withAnimation(.easeIn(duration: 0.2)) {
                self.image = loadedImage
            }
        } catch {
            // Silently fail — placeholder remains visible
        }

        isLoading = false
    }
}

// Convenience initializer with default placeholder
extension CachedAsyncImage where Placeholder == ShimmerPlaceholder {
    init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content) {
        self.url = url
        self.content = content
        self.placeholder = { ShimmerPlaceholder() }
    }
}

struct ShimmerPlaceholder: View {
    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        GeometryReader { geometry in
            FHColors.linen
                .overlay(
                    LinearGradient(
                        colors: [
                            .clear,
                            FHColors.warmWhite.opacity(0.5),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: shimmerOffset * geometry.size.width)
                )
                .clipped()
        }
        .onAppear {
            withAnimation(
                .linear(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                shimmerOffset = 2
            }
        }
    }
}
