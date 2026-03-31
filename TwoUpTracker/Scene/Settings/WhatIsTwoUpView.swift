import ASKCoordinator
import Foundation
import SwiftUI

struct WhatIsTwoUpView: View {
    private let wikipediaURL = URL(string: "https://en.wikipedia.org/wiki/Two-up")!

    let coordinator: Coordinator?

    var body: some View {
        PageLayout {
            HStack(spacing: 0) {
                Button(
                    action: { coordinator?.pop()},
                    label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .fontWeight(.bold)
                            .padding(8)
                            .frame(width: 44, height: 44)
                            .foregroundStyle(Color.primary)
                    }
                )
                PageHeader(title: "What is Two-Up")
            }
        } content: {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.large) {
                    section1

                    section2

                    section3

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
    }

    private var section1: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "What is Two-Up?")
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
            }
        }
    }

    private var section2: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "How a round works")

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("1. A spinner tosses two coins into the air.")
                    Text("2. Before the toss, players place bets for heads or tails.")
                    Text(
                        "3. Two heads means the spinner wins their wager, " +
                            "two tails means the spinner loses it, and odds results in another toss " +
                            "with the head/tail bets frozen."
                    )
                    Text(
                        "4. The game is run by roles such as a boxer (who manages betting/equipment) " +
                            "and a ringkeeper (who monitors the toss and resets the kip)."
                    )
                }
                .font(DesignTokens.Typography.body)
            }
        }
    }

    private var section3: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "Common terminology")

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("Spinner:").bold() + Text(" the person who throws the coins.")
                    Text("Boxer:").bold() + Text(" the person who manages the game (bets and equipment).")
                    Text("Ring / ringkeeper (ringie):").bold() +
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
