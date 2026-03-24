import SwiftUI

@Observable
final class AppState {
    var selectedTab: AppTab = .home
    var hasCompletedOnboarding: Bool = false

    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "plated_onboarding_completed")
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "plated_onboarding_completed")
    }
}

enum AppTab: String, CaseIterable, Hashable {
    case home, explore, saved, profile

    var title: String {
        rawValue.capitalized
    }

    var systemImage: String {
        switch self {
        case .home: return "house"
        case .explore: return "magnifyingglass"
        case .saved: return "bookmark"
        case .profile: return "person"
        }
    }
}
