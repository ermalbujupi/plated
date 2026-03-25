import SwiftUI

enum FHColors {
    // Backgrounds — WarKitchen cream palette
    static let cream = Color(red: 1.0, green: 0.988, blue: 0.949)           // #FFFCF2
    static let warmWhite = Color(red: 0.992, green: 0.988, blue: 0.980)     // #FDFCFA
    static let linen = Color(red: 0.949, green: 0.929, blue: 0.898)         // #F2EDE5

    // Text — WarKitchen deep brown
    static let deepBrown = Color(red: 0.263, green: 0.157, blue: 0.094)     // #432818
    static let deepBrownSecondary = Color(red: 0.369, green: 0.290, blue: 0.227) // #5E4A3A
    static let deepBrownTertiary = Color(red: 0.545, green: 0.451, blue: 0.333)  // #8B7355

    // Accents — olive/sage palette
    static let olive = Color(red: 0.478, green: 0.514, blue: 0.384)         // #7A8362
    static let oliveLight = Color(red: 0.627, green: 0.659, blue: 0.553)    // #A0A88D
    static let sage = Color(red: 0.498, green: 0.569, blue: 0.471)          // #7F9178
    static let sageLight = Color(red: 0.698, green: 0.753, blue: 0.682)

    // Legacy aliases
    static let terracotta = olive
    static let terracottaLight = oliveLight
    static let stone = Color(red: 0.647, green: 0.608, blue: 0.561)         // #A59B8F
    static let warmGray = Color(red: 0.847, green: 0.824, blue: 0.792)      // #D8D2CA

    // Utility
    static let divider = Color(red: 0.878, green: 0.859, blue: 0.831)       // #E0DBD4
    static let cardBackground = Color.white
    static let overlay = Color.black.opacity(0.45)
    static let overlayLight = Color.black.opacity(0.25)
}
