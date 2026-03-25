import SwiftUI

enum ExploreCategory: String, CaseIterable, Identifiable {
    case quickMeals = "Quick Meals"
    case breakfast = "Breakfast"
    case dinner = "Dinner"
    case desserts = "Desserts"
    case cozy = "Cozy"
    case fresh = "Fresh"
    case pasta = "Pasta"
    case salads = "Salads"
    case spring = "Spring"
    case weekendCooking = "Weekend Cooking"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .quickMeals: return "bolt"
        case .breakfast: return "sunrise"
        case .dinner: return "moon.stars"
        case .desserts: return "birthday.cake"
        case .cozy: return "flame"
        case .fresh: return "leaf"
        case .pasta: return "fork.knife"
        case .salads: return "carrot"
        case .spring: return "flower"
        case .weekendCooking: return "calendar"
        }
    }

    var color: Color {
        switch self {
        case .quickMeals: return FHColors.terracotta
        case .breakfast: return FHColors.sage
        case .dinner: return FHColors.deepBrown
        case .desserts: return FHColors.terracottaLight
        case .cozy: return FHColors.stone
        case .fresh: return FHColors.sage
        case .pasta: return FHColors.terracotta
        case .salads: return FHColors.sageLight
        case .spring: return FHColors.sage
        case .weekendCooking: return FHColors.stone
        }
    }
}
