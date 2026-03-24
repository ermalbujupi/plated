import SwiftUI

struct EditorialBlockView: View {
    let title: String
    let editorials: [Editorial]

    var body: some View {
        VStack(alignment: .leading, spacing: PlatedSpacing.md) {
            SectionHeader(title: title, showSeeAll: true)
                .screenHorizontalPadding()

            VStack(spacing: PlatedSpacing.lg) {
                ForEach(editorials) { editorial in
                    NavigationLink(value: Route.editorialDetail(id: editorial.id)) {
                        EditorialCard(editorial: editorial)
                    }
                    .buttonStyle(.plain)
                }
            }
            .screenHorizontalPadding()
        }
    }
}
