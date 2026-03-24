import SwiftUI

struct HeroHeaderView: View {
    let imageURL: URL?
    var height: CGFloat = 400
    var overlayAlignment: Alignment = .bottomLeading
    var content: (() -> AnyView)? = nil

    var body: some View {
        GeometryReader { geometry in
            let minY = geometry.frame(in: .global).minY
            let isStretching = minY > 0

            CachedAsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(
                width: geometry.size.width,
                height: height + (isStretching ? minY : 0)
            )
            .clipped()
            .offset(y: isStretching ? -minY : 0)
            .overlay(alignment: overlayAlignment) {
                if let content {
                    content()
                        .padding(PlatedSpacing.xl)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            }
        }
        .frame(height: height)
    }
}
