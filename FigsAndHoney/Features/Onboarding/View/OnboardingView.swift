import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            HStack(spacing: FHSpacing.xxs) {
                ForEach(0..<viewModel.totalPages, id: \.self) { index in
                    Capsule()
                        .fill(index <= viewModel.currentPage ? FHColors.deepBrown : FHColors.warmGray)
                        .frame(height: 3)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
                }
            }
            .padding(.horizontal, FHSpacing.xxl)
            .padding(.top, FHSpacing.lg)

            // Skip button
            HStack {
                Spacer()
                if !viewModel.isLastPage {
                    Button("Skip") {
                        Task {
                            await viewModel.complete()
                            onComplete()
                        }
                    }
                    .font(FHTypography.uiCallout)
                    .foregroundStyle(FHColors.deepBrownTertiary)
                }
            }
            .padding(.horizontal, FHSpacing.screenHorizontal)
            .padding(.top, FHSpacing.sm)
            .frame(height: 40)

            // Page content
            TabView(selection: $viewModel.currentPage) {
                WelcomePage()
                    .tag(0)

                DietaryPreferencePage(
                    selected: viewModel.selectedDietary,
                    onToggle: { viewModel.toggleDietary($0) }
                )
                .tag(1)

                CuisinePreferencePage(
                    selectedCuisines: viewModel.selectedCuisines,
                    selectedMoods: viewModel.selectedMoods,
                    onToggleCuisine: { viewModel.toggleCuisine($0) },
                    onToggleMood: { viewModel.toggleMood($0) }
                )
                .tag(2)

                CompletionPage()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)

            // Bottom action
            VStack(spacing: FHSpacing.sm) {
                FHButton(
                    title: viewModel.isLastPage ? "Start Exploring" : "Continue",
                    style: .primary
                ) {
                    if viewModel.isLastPage {
                        Haptics.success()
                        Task {
                            await viewModel.complete()
                            onComplete()
                        }
                    } else {
                        viewModel.nextPage()
                    }
                }

                if viewModel.currentPage > 0 && !viewModel.isLastPage {
                    Button("Back") {
                        viewModel.previousPage()
                    }
                    .font(FHTypography.uiCallout)
                    .foregroundStyle(FHColors.deepBrownSecondary)
                }
            }
            .padding(.horizontal, FHSpacing.screenHorizontal)
            .padding(.bottom, FHSpacing.xxl)
        }
        .background(FHColors.cream)
    }
}
