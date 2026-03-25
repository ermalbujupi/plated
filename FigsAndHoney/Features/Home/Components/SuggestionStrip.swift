import SwiftUI

struct SuggestionStrip: View {
    let suggestions: [Suggestion]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: FHSpacing.sm) {
                ForEach(suggestions) { suggestion in
                    NavigationLink(value: Route.suggestionDetail(id: suggestion.id)) {
                        SuggestionTile(suggestion: suggestion)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, FHSpacing.screenHorizontal)
        }
    }
}
