import SwiftUI

enum FHTypography {
    // MARK: - Spectral Serif (Editorial voice — headlines, article body, pull quotes)
    // Bundled Spectral font from Google Fonts, matching WarKitchen's editorial feel

    static let serifDisplayLarge = Font.custom("Spectral-Bold", size: 34, relativeTo: .largeTitle)
    static let serifDisplay = Font.custom("Spectral-SemiBold", size: 28, relativeTo: .title)
    static let serifTitle = Font.custom("Spectral-SemiBold", size: 22, relativeTo: .title2)
    static let serifTitle3 = Font.custom("Spectral-Medium", size: 20, relativeTo: .title3)
    static let serifHeadline = Font.custom("Spectral-SemiBold", size: 17, relativeTo: .headline)
    static let serifBody = Font.custom("Spectral-Regular", size: 17, relativeTo: .body)
    static let serifBodyMedium = Font.custom("Spectral-Medium", size: 17, relativeTo: .body)
    static let serifCallout = Font.custom("Spectral-Regular", size: 16, relativeTo: .callout)
    static let serifCaption = Font.custom("Spectral-Medium", size: 12, relativeTo: .caption)
    static let serifItalic = Font.custom("Spectral-Italic", size: 17, relativeTo: .body)

    // MARK: - SF Pro (UI elements — metadata, navigation, buttons, labels)

    static let uiLargeTitle = Font.system(.largeTitle, design: .default, weight: .bold)
    static let uiTitle = Font.system(.title, design: .default, weight: .semibold)
    static let uiTitle2 = Font.system(.title2, design: .default, weight: .semibold)
    static let uiTitle3 = Font.system(.title3, design: .default, weight: .medium)
    static let uiHeadline = Font.system(.headline, design: .default, weight: .semibold)
    static let uiSubheadline = Font.system(.subheadline, design: .default, weight: .medium)
    static let uiBody = Font.system(.body, design: .default, weight: .regular)
    static let uiBodyMedium = Font.system(.body, design: .default, weight: .medium)
    static let uiCallout = Font.system(.callout, design: .default, weight: .regular)
    static let uiCaption = Font.system(.caption, design: .default, weight: .medium)
    static let uiCaption2 = Font.system(.caption2, design: .default, weight: .regular)
    static let uiFootnote = Font.system(.footnote, design: .default, weight: .regular)

    // MARK: - Overline (category labels, section tags)
    static let overline = Font.system(size: 11, weight: .semibold, design: .default)
}
