import ASKCoordinator
import Foundation
import SwiftUI

// swiftlint:disable line_length
struct WhatIsTwoUpView: View {
    private let wikipediaURL = URL(string: "https://en.wikipedia.org/wiki/Two-up")!

    let coordinator: Coordinator?

    var body: some View {
        content
            .navigationTitle("What is Two-up")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("What is Two-up")
                        .font(DesignTokens.Typography.display)
                }
            }
    }
    
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.large) {
                section1
                terminologySection

                roundSection
                howToPlaySection

                section4

                Card {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                        SectionHeader(title: "Source")
                        Link("Wikipedia: Two-up", destination: wikipediaURL)
                            .font(DesignTokens.Typography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, .margin)
            .padding(.bottom, DesignTokens.Spacing.medium)
        }
    }

    private var section1: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "What is Two-up?")
                Text(
                    "Two-up is a traditional Australian coin-toss game. A designated " +
                        "spinner throws two coins, and players bet on the outcome."
                )
                .font(DesignTokens.Typography.body)

                Text(
                    "The result can be:\n" +
                        "- Both heads\n" +
                        "- Both tails\n" +
                        "- Odds (one head and one tail)"
                )
                .font(DesignTokens.Typography.body)

                Text("Some places may use 3 coins so every spin gives a result.")
            }
        }
    }

    private var howToPlaySection: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "How to place side bets")

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("If you want to bet on heads, hold the money for your wager above your head. If you want to bet on tails, find someone holding money above their head. The heads better holds the money for both players until the round concludes.")
                    Text("If the round results is heads then the heads better keeps the money. If the round is tails then the tails better collects their winnings from the heads better.")
                }
                .font(DesignTokens.Typography.body)
            }
        }
    }

    private var roundSection: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "How a round works")

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("1. Before the toss, players place bets for heads or tails.")
                    Text("2. A chosen spinner tosses two coins into the air.")
                    Text(
                        "3. Two heads means the spinner wins their wager, " +
                            "two tails means the spinner loses it, and odds results in another toss "
                    )
                    Text("4. The coins must fly three metres into the air, not touch the roof and have to fall within the ring.")
                    Text("5. The ringkeeper monitors the toss and resets the kip.")
                }
                .font(DesignTokens.Typography.body)
            }
        }
    }

    private var terminologySection: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "Common terminology")

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("Spinner:").bold() + Text(" the person who throws the coins.")
                    Text("Ringkeeper (ringie):").bold() +
                    Text(
                        " the ring is the play area; the ringkeeper calls validity and resets."
                    )
                    Text("Kip:").bold() +
                    Text(" A piece of wood used to toss the coins.")
                    Text("Heads / tails:").bold() +
                    Text(" the two possible matching outcomes.")
                    Text("Odds:").bold() +
                    Text(" one coin is heads and the other is tails.")
                }
                .font(DesignTokens.Typography.body)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var section4: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "A short history")
                Text(
                    "The exact origins are obscure, but the two-coin form is believed to have " +
                        "developed from earlier one-coin games. It spread widely during gold rushes, " +
                        "and became especially associated with Australian soldiers in World War I " +
                        "(and the Anzac Day tradition)."
                )
                .font(DesignTokens.Typography.body)

                Text(
                    "Today, two-up is legal in some jurisdictions (including specific Anzac Day offerings) " +
                        "and is also offered as a casino table game in certain places."
                )
                .font(DesignTokens.Typography.body)
            }
        }
    }
}

#Preview {
    WhatIsTwoUpView(coordinator: nil)
}
// swiftlint:enable line_length
