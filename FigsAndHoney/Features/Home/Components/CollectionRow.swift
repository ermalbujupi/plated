import SwiftUI

struct CollectionRow: View {
    let collection: FoodCollection

    var body: some View {
        VStack(alignment: .leading, spacing: FHSpacing.md) {
            SectionHeader(title: "Curated Collection", showSeeAll: false)
                .screenHorizontalPadding()

            NavigationLink(value: Route.collectionDetail(id: collection.id)) {
                CollectionCard(collection: collection)
            }
            .buttonStyle(.plain)
            .screenHorizontalPadding()
        }
    }
}
