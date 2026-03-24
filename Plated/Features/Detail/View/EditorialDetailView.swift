import SwiftUI

struct EditorialDetailView: View {
    @Bindable var viewModel: EditorialDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let editorial = viewModel.editorial {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero
                    HeroHeaderView(imageURL: editorial.heroImageURL, height: 340)

                    VStack(alignment: .leading, spacing: PlatedSpacing.xl) {
                        // Header
                        VStack(alignment: .leading, spacing: PlatedSpacing.xs) {
                            Text(editorial.category.displayName.uppercased())
                                .font(PlatedTypography.overline)
                                .tracking(1.5)
                                .foregroundStyle(PlatedColors.terracotta)

                            Text(editorial.headline)
                                .font(PlatedTypography.serifDisplay)
                                .foregroundStyle(PlatedColors.deepBrown)

                            if let subheadline = editorial.subheadline {
                                Text(subheadline)
                                    .font(PlatedTypography.serifCallout)
                                    .foregroundStyle(PlatedColors.deepBrownSecondary)
                            }

                            HStack(spacing: PlatedSpacing.xs) {
                                Text("By \(editorial.author.name)")
                                Text("\u{00B7}")
                                Text("\(editorial.readingTimeMinutes) min read")
                            }
                            .font(PlatedTypography.uiCaption)
                            .foregroundStyle(PlatedColors.deepBrownTertiary)
                            .padding(.top, PlatedSpacing.xxs)
                        }
                        .screenHorizontalPadding()

                        ContentDivider()

                        // Body blocks
                        VStack(alignment: .leading, spacing: PlatedSpacing.lg) {
                            ForEach(Array(editorial.body.enumerated()), id: \.offset) { _, block in
                                editorialBlockView(block)
                            }
                        }
                        .screenHorizontalPadding()

                        // Related recipes
                        if !viewModel.relatedRecipes.isEmpty {
                            ContentDivider()
                            RelatedContentRow(title: "Recipes in This Story", recipes: viewModel.relatedRecipes)
                        }
                    }
                    .padding(.vertical, PlatedSpacing.xl)
                }
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 400)
            }
        }
        .background(PlatedColors.cream)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                SaveButton(isSaved: viewModel.isSaved) {
                    Task { await viewModel.toggleSave() }
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private func editorialBlockView(_ block: EditorialBlock) -> some View {
        switch block {
        case .paragraph(let text):
            Text(text)
                .font(PlatedTypography.serifBody)
                .foregroundStyle(PlatedColors.deepBrown)
                .lineSpacing(6)

        case .heading(let text):
            Text(text)
                .font(PlatedTypography.serifTitle3)
                .foregroundStyle(PlatedColors.deepBrown)
                .padding(.top, PlatedSpacing.xs)

        case .image(let url, let caption):
            VStack(spacing: PlatedSpacing.xs) {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.image, style: .continuous))

                if let caption {
                    Text(caption)
                        .font(PlatedTypography.uiCaption)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                        .italic()
                }
            }

        case .pullQuote(let text, let attribution):
            VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
                Rectangle()
                    .fill(PlatedColors.terracotta)
                    .frame(width: 40, height: 3)

                Text(text)
                    .font(PlatedTypography.serifItalic)
                    .foregroundStyle(PlatedColors.deepBrown)
                    .lineSpacing(6)

                if let attribution {
                    Text("\u{2014} \(attribution)")
                        .font(PlatedTypography.uiCaption)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                }
            }
            .padding(.vertical, PlatedSpacing.md)
            .padding(.leading, PlatedSpacing.lg)

        case .recipeEmbed(let recipeID):
            NavigationLink(value: Route.recipeDetail(id: recipeID)) {
                HStack(spacing: PlatedSpacing.sm) {
                    Image(systemName: "book")
                        .foregroundStyle(PlatedColors.terracotta)
                    Text("View Recipe")
                        .font(PlatedTypography.uiBodyMedium)
                        .foregroundStyle(PlatedColors.terracotta)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(PlatedColors.terracotta)
                }
                .padding(PlatedSpacing.md)
                .background(PlatedColors.terracotta.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: PlatedRadius.sm, style: .continuous))
            }
        }
    }
}
