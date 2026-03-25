import SwiftUI

struct ContentDivider: View {
    var body: some View {
        Rectangle()
            .fill(FHColors.divider)
            .frame(height: 1)
            .padding(.horizontal, FHSpacing.screenHorizontal)
    }
}
