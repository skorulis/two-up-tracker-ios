import SwiftUI

/// Primary action style with a full-width minimum height for large tap targets.
struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = Color.accentColor

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignTokens.Typography.buttonLabel)
            .frame(minHeight: DesignTokens.MinTapTarget.height)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, DesignTokens.Spacing.medium)
            .background(backgroundColor.opacity(configuration.isPressed ? 0.88 : 1))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button, style: .continuous))
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

#if !os(Android)
#Preview("Primary button") {
    Button("Save Round") {}
        .buttonStyle(.primary)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.groupedBackground)
}
#endif
