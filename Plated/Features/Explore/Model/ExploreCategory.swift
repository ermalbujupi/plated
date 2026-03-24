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
        case .quickMeals: return PlatedColors.terracotta
        case .breakfast: return PlatedColors.sage
        case .dinner: return PlatedColors.deepBrown
        case .desserts: return PlatedColors.terracottaLight
        case .cozy: return PlatedColors.stone
        case .fresh: return PlatedColors.sage
        case .pasta: return PlatedColors.terracotta
        case .salads: return PlatedColors.sageLight
        case .spring: return PlatedColors.sage
        case .weekendCooking: return PlatedColors.stone
        }
    }
}
