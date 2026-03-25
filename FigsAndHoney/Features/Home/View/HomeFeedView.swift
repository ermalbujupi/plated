import SwiftUI

struct HomeFeedView: View {
    @Bindable var viewModel: HomeFeedViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: FHSpacing.feedSectionGap) {
                // Brand header
                VStack(spacing: FHSpacing.xxs) {
                    Text("Figs & Honey")
                        .font(FHTypography.serifDisplayLarge)
                        .foregroundStyle(FHColors.deepBrown)

                    Text("curated food for the senses")
                        .font(FHTypography.uiCaption)
                        .foregroundStyle(FHColors.deepBrownTertiary)
                        .tracking(1.0)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, FHSpacing.sm)
                .padding(.bottom, FHSpacing.md)

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
            .padding(.bottom, FHSpacing.xxxxl)
        }
        .background(FHColors.cream)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            if viewModel.sections.isEmpty {
                await viewModel.loadFeed()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(FHColors.cream, for: .navigationBar)
    }

    private var loadingView: some View {
        VStack(spacing: FHSpacing.xl) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerPlaceholder()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: FHRadius.card, style: .continuous))
                    .screenHorizontalPadding()
            }
        }
    }

    private func errorView(_ error: Error) -> some View {
        VStack(spacing: FHSpacing.md) {
            Text("Something went wrong")
                .font(FHTypography.serifHeadline)
                .foregroundStyle(FHColors.deepBrown)

            Text(error.localizedDescription)
                .font(FHTypography.uiCallout)
                .foregroundStyle(FHColors.deepBrownSecondary)
                .multilineTextAlignment(.center)

            FHButton(title: "Try Again", style: .secondary) {
                Task { await viewModel.loadFeed() }
            }
            .frame(width: 160)
        }
        .padding(.top, FHSpacing.xxxxl)
        .screenHorizontalPadding()
    }
}
