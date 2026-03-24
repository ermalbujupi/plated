import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            HStack(spacing: PlatedSpacing.xxs) {
                ForEach(0..<viewModel.totalPages, id: \.self) { index in
                    Capsule()
                        .fill(index <= viewModel.currentPage ? PlatedColors.deepBrown : PlatedColors.warmGray)
                        .frame(height: 3)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
                }
            }
            .padding(.horizontal, PlatedSpacing.xxl)
            .padding(.top, PlatedSpacing.lg)

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
                    .font(PlatedTypography.uiCallout)
                    .foregroundStyle(PlatedColors.deepBrownTertiary)
                }
            }
            .padding(.horizontal, PlatedSpacing.screenHorizontal)
            .padding(.top, PlatedSpacing.sm)
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
            VStack(spacing: PlatedSpacing.sm) {
                PlatedButton(
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
                    .font(PlatedTypography.uiCallout)
                    .foregroundStyle(PlatedColors.deepBrownSecondary)
                }
            }
            .padding(.horizontal, PlatedSpacing.screenHorizontal)
            .padding(.bottom, PlatedSpacing.xxl)
        }
        .background(PlatedColors.cream)
    }
}
