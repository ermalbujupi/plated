import SwiftUI

struct HomeFeedView: View {
    @Bindable var viewModel: HomeFeedViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: PlatedSpacing.feedSectionGap) {
                // Brand header
                VStack(spacing: PlatedSpacing.xxs) {
                    Text("Plated")
                        .font(PlatedTypography.serifDisplayLarge)
                        .foregroundStyle(PlatedColors.deepBrown)

                    Text("curated food for the senses")
                        .font(PlatedTypography.uiCaption)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                        .tracking(1.0)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, PlatedSpacing.sm)
                .padding(.bottom, PlatedSpacing.md)

                if viewModel.isLoading && viewModel.sections.isEmpty {
                    loadingView
                } else if let error = viewModel.error, viewModel.sections.isEmpty {
                    errorView(error)
                } else {
                    ForEach(viewModel.sections) { section in
                        HomeSectionView(section: section)
                    }
                }
            }
            .padding(.bottom, PlatedSpacing.xxxxl)
        }
        .background(PlatedColors.cream)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            if viewModel.sections.isEmpty {
                await viewModel.loadFeed()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(PlatedColors.cream, for: .navigationBar)
    }

    private var loadingView: some View {
        VStack(spacing: PlatedSpacing.xl) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerPlaceholder()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.card, style: .continuous))
                    .screenHorizontalPadding()
            }
        }
    }

    private func errorView(_ error: Error) -> some View {
        VStack(spacing: PlatedSpacing.md) {
            Text("Something went wrong")
                .font(PlatedTypography.serifHeadline)
                .foregroundStyle(PlatedColors.deepBrown)

            Text(error.localizedDescription)
                .font(PlatedTypography.uiCallout)
                .foregroundStyle(PlatedColors.deepBrownSecondary)
                .multilineTextAlignment(.center)

            PlatedButton(title: "Try Again", style: .secondary) {
                Task { await viewModel.loadFeed() }
            }
            .frame(width: 160)
        }
        .padding(.top, PlatedSpacing.xxxxl)
        .screenHorizontalPadding()
    }
}
