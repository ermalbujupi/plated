import SwiftUI

struct InstructionStepView: View {
    let stepNumber: Int
    let instruction: String

    var body: some View {
        HStack(alignment: .top, spacing: FHSpacing.md) {
            Text("\(stepNumber)")
                .font(FHTypography.serifTitle3)
                .foregroundStyle(FHColors.terracotta)
                .frame(width: 28)

            Text(instruction)
                .font(FHTypography.serifBody)
                .foregroundStyle(FHColors.deepBrown)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
