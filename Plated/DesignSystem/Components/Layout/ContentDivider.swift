import SwiftUI

struct ContentDivider: View {
    var body: some View {
        Rectangle()
            .fill(PlatedColors.divider)
            .frame(height: 1)
            .padding(.horizontal, PlatedSpacing.screenHorizontal)
    }
}
