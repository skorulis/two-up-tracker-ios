import SwiftUI

/// Circular coin image button for choosing a two-up toss result (`heads` / `tails`).
struct CoinOutcomeButton: View {
    let outcome: Outcome
    var diameter: CGFloat = 72
    var borderColor: Color = .clear
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .center) {
                Image(asset: asset)
                    .resizable()
                    .scaledToFill()
                    .frame(width: diameter, height: diameter)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .strokeBorder(borderColor, lineWidth: 3)
                            .frame(width: diameter + 4, height: diameter + 4)
                    }

                Text(label)
                    .font(DesignTokens.Typography.buttonLabel)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.55), radius: 2, x: 0, y: 1)
                    .padding(.top, DesignTokens.Spacing.xs)
            }
            .contentShape(Circle())
        }
        .buttonStyle(CoinOutcomeButtonPressStyle())
        .accessibilityLabel(label)
    }

    private var label: String {
        outcome == .heads ? "Heads" : "Tails"
    }

    private var asset: ImageAsset {
        switch outcome {
        case .heads:
            Asset.heads
        case .tails:
            Asset.tails
        }
    }
}

struct CoinOutcomeRow: View {

    @Binding var selectedOutcome: Outcome?

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.large) {
            CoinOutcomeButton(
                outcome: .heads,
                borderColor: selectedOutcome == .heads ? Colors.australianGreen : .clear
            ) {
                selectedOutcome = .heads
            }
            CoinOutcomeButton(
                outcome: .tails,
                borderColor: selectedOutcome == .tails ? Colors.australianGold : .clear
            ) {
                selectedOutcome = .tails
            }
        }
    }
}

private struct CoinOutcomeButtonPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview("Coin outcome buttons") {
    CoinOutcomeRow(selectedOutcome: .constant(nil))
    .padding()
    .background(Colors.groupedBackground)
}
