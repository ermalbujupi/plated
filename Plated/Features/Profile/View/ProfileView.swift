import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel: ProfileViewModel

    private let cuisines = ["Italian", "Japanese", "Mexican", "French", "Thai", "Indian", "Mediterranean", "Korean", "American", "Middle Eastern"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: PlatedSpacing.sectionSpacing) {
                // Header
                VStack(spacing: PlatedSpacing.xs) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 60, weight: .ultraLight))
                        .foregroundStyle(PlatedColors.stone)

                    Text("Your Preferences")
                        .font(PlatedTypography.serifTitle)
                        .foregroundStyle(PlatedColors.deepBrown)

                    Text("Personalize your Plated experience")
                        .font(PlatedTypography.uiCallout)
                        .foregroundStyle(PlatedColors.deepBrownTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, PlatedSpacing.lg)

                // Skill level
                VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
                    Text("Cooking Level")
                        .font(PlatedTypography.serifTitle3)
                        .foregroundStyle(PlatedColors.deepBrown)

                    HStack(spacing: PlatedSpacing.sm) {
                        ForEach(UserPreferences.SkillLevel.allCases, id: \.self) { level in
                            FilterChip(
                                title: level.displayName,
                                isSelected: viewModel.preferences.skillLevel == level
                            ) {
                                Task { await viewModel.setSkillLevel(level) }
                            }
                        }
                    }
                }
                .screenHorizontalPadding()

                // Dietary
                DietarySection(
                    selectedRestrictions: viewModel.preferences.dietaryRestrictions
                ) { restriction in
                    Task { await viewModel.toggleDietary(restriction) }
                }
                .screenHorizontalPadding()

                // Favorite cuisines
                VStack(alignment: .leading, spacing: PlatedSpacing.sm) {
                    Text("Favorite Cuisines")
                        .font(PlatedTypography.serifTitle3)
                        .foregroundStyle(PlatedColors.deepBrown)

                    FlowLayout(spacing: PlatedSpacing.xs) {
                        ForEach(cuisines, id: \.self) { cuisine in
                            FilterChip(
                                title: cuisine,
                                isSelected: viewModel.preferences.favoriteCuisines.contains(cuisine)
                            ) {
                                Task { await viewModel.toggleCuisine(cuisine) }
                            }
                        }
                    }
                }
                .screenHorizontalPadding()

                ContentDivider()

                // About
                AboutSection()
                    .screenHorizontalPadding()
            }
            .padding(.bottom, PlatedSpacing.xxxxl)
        }
        .background(PlatedColors.cream)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.load()
        }
    }
}

// MARK: - FlowLayout (wrapping layout for chips)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: ProposedViewSize(width: bounds.width, height: bounds.height), subviews: subviews)

        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: ProposedViewSize(subviews[index].sizeThatFits(.unspecified))
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX - spacing)
        }

        return (CGSize(width: maxX, height: currentY + lineHeight), positions)
    }
}
