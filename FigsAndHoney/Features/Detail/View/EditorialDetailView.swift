import SwiftUI

struct EditorialDetailView: View {
    @Bindable var viewModel: EditorialDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let editorial = viewModel.editorial {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero
                    HeroHeaderView(imageURL: editorial.heroImageURL, height: 340)

                    VStack(alignment: .leading, spacing: FHSpacing.xl) {
                        // Header
                        VStack(alignment: .leading, spacing: FHSpacing.xs) {
                            Text(editorial.category.displayName.uppercased())
                                .font(FHTypography.overline)
                                .tracking(1.5)
                                .foregroundStyle(FHColors.terracotta)

                            Text(editorial.headline)
                                .font(FHTypography.serifDisplay)
                                .foregroundStyle(FHColors.deepBrown)

                            if let subheadline = editorial.subheadline {
                                Text(subheadline)
                                    .font(FHTypography.serifCallout)
                                    .foregroundStyle(FHColors.deepBrownSecondary)
                            }

                            HStack(spacing: FHSpacing.xs) {
                                Text("By \(editorial.author.name)")
                                Text("\u{00B7}")
                                Text("\(editorial.readingTimeMinutes) min read")
                            }
                            .font(FHTypography.uiCaption)
                            .foregroundStyle(FHColors.deepBrownTertiary)
                            .padding(.top, FHSpacing.xxs)
                        }
                        .screenHorizontalPadding()

                        ContentDivider()

                        // Body blocks
                        VStack(alignment: .leading, spacing: FHSpacing.lg) {
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
                    .padding(.vertical, FHSpacing.xl)
                }
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 400)
            }
        }
        .background(FHColors.cream)
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
                .font(FHTypography.serifBody)
                .foregroundStyle(FHColors.deepBrown)
                .lineSpacing(6)

        case .heading(let text):
            Text(text)
                .font(FHTypography.serifTitle3)
                .foregroundStyle(FHColors.deepBrown)
                .padding(.top, FHSpacing.xs)

        case .image(let url, let caption):
            VStack(spacing: FHSpacing.xs) {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: FHRadius.image, style: .continuous))

                if let caption {
                    Text(caption)
                        .font(FHTypography.uiCaption)
                        .foregroundStyle(FHColors.deepBrownTertiary)
                        .italic()
                }
            }

        case .pullQuote(let text, let attribution):
            VStack(alignment: .leading, spacing: FHSpacing.sm) {
                Rectangle()
                    .fill(FHColors.terracotta)
                    .frame(width: 40, height: 3)

                Text(text)
                    .font(FHTypography.serifItalic)
                    .foregroundStyle(FHColors.deepBrown)
                    .lineSpacing(6)

                if let attribution {
                    Text("\u{2014} \(attribution)")
                        .font(FHTypography.uiCaption)
                        .foregroundStyle(FHColors.deepBrownTertiary)
                }
            }
            .padding(.vertical, FHSpacing.md)
            .padding(.leading, FHSpacing.lg)

        case .recipeEmbed(let recipeID):
            NavigationLink(value: Route.recipeDetail(id: recipeID)) {
                HStack(spacing: FHSpacing.sm) {
                    Image(systemName: "book")
                        .foregroundStyle(FHColors.terracotta)
                    Text("View Recipe")
                        .font(FHTypography.uiBodyMedium)
                        .foregroundStyle(FHColors.terracotta)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(FHColors.terracotta)
                }
                .padding(FHSpacing.md)
                .background(FHColors.terracotta.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: FHRadius.sm, style: .continuous))
            }
        }
    }
}
