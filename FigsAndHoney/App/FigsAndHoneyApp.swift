import SwiftUI

@main
struct FigsAndHoneyApp: App {
    @State private var appState = AppState()
    @State private var router = Router()
    @State private var container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            RootView(appState: appState, router: router, container: container)
                .environment(container)
                .environment(router)
                .preferredColorScheme(.light)
        }
    }
}

/// Top-level routing logic, split out so we can use `@Environment` cleanly.
///
/// Hierarchy:
///   .unknown   → splash (avoid flashing the auth screen on launch)
///   .signedOut → AuthScreen
///   .signedIn  → Onboarding (first time) or AppTabView
private struct RootView: View {
    @Bindable var appState: AppState
    let router: Router
    let container: DependencyContainer

    var body: some View {
        Group {
            switch container.authService.state {
            case .unknown:
                SplashView()

            case .signedOut:
                AuthScreen(authService: container.authService)
                    .transition(.opacity)

            case .signedIn:
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
        }
        .animation(.easeInOut(duration: 0.25), value: stateID)
        .task {
            // Bootstrap on first appearance — checks Keychain for existing tokens.
            await container.authService.bootstrap()
        }
    }

    /// Used to drive the cross-fade animation when auth state changes.
    private var stateID: String {
        switch container.authService.state {
        case .unknown:   return "unknown"
        case .signedOut: return "signedOut"
        case .signedIn:  return "signedIn"
        }
    }
}

/// Bare splash to avoid flicker between launch and bootstrap completing.
private struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            Text("🍯")
                .font(.system(size: 64))
        }
    }
}
