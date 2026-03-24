import SwiftUI

@Observable
final class Router {
    var homePath = NavigationPath()
    var explorePath = NavigationPath()
    var savedPath = NavigationPath()
    var profilePath = NavigationPath()

    func navigate(to route: Route, from tab: AppTab) {
        switch tab {
        case .home: homePath.append(route)
        case .explore: explorePath.append(route)
        case .saved: savedPath.append(route)
        case .profile: profilePath.append(route)
        }
    }

    func popToRoot(tab: AppTab) {
        switch tab {
        case .home: homePath = NavigationPath()
        case .explore: explorePath = NavigationPath()
        case .saved: savedPath = NavigationPath()
        case .profile: profilePath = NavigationPath()
        }
    }
}
