import SwiftUI

struct InstructionStepView: View {
    let stepNumber: Int
    let instruction: String

    var body: some View {
        HStack(alignment: .top, spacing: PlatedSpacing.md) {
            Text("\(stepNumber)")
                .font(PlatedTypography.serifTitle3)
                .foregroundStyle(PlatedColors.terracotta)
                .frame(width: 28)

            Text(instruction)
                .font(PlatedTypography.serifBody)
                .foregroundStyle(PlatedColors.deepBrown)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
