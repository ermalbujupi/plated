import SwiftUI

@main
struct PlatedApp: App {
    @State private var appState = AppState()
    @State private var router = Router()
    @State private var container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.hasCompletedOnboarding {
                    AppTabView(
                        router: router,
                        appState: appState,
                        container: container
                    )
                } else {
                    OnboardingView(
                        viewModel: OnboardingViewModel(
                            preferencesRepository: container.userPreferencesRepository
                        ),
                        onComplete: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                appState.completeOnboarding()
                            }
                        }
                    )
                }
            }
            .environment(container)
            .environment(router)
            .preferredColorScheme(.light)
        }
    }
}
