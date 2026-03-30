import Foundation
import SwiftUI

struct WhatIsTwoUpView: View {
    private let wikipediaURL = URL(string: "https://en.wikipedia.org/wiki/Two-up")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.large) {
                PageHeader(title: "What is Two-Up")

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

                Card {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                        SectionHeader(title: "How a round works")

                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            Text("1. A spinner tosses two coins into the air.")
                            Text("2. Before the toss, players place bets for heads, tails, or odds.")
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

                Card {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                        SectionHeader(title: "Common terminology")

                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            Text("Spinner: the person who throws the coins.")
                            Text("Boxer: the person who manages the game (bets and equipment).")
                            Text(
                                "Ring / ringkeeper (ringie): the ring is the play area; " +
                                    "the ringkeeper calls validity and resets."
                            )
                            Text("Kip: the surface the coins rest on before being tossed.")
                            Text("Heads / tails: the two possible matching outcomes.")
                            Text("Odds (one them): one coin is heads and the other is tails.")
                            Text(
                                "Odding out: spinning odds repeatedly until the game resolves " +
                                    "(casino rule variants exist)."
                            )
                        }
                        .font(DesignTokens.Typography.body)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }

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

                Card {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                        SectionHeader(title: "Source")
                        Link("Wikipedia: Two-up", destination: wikipediaURL)
                            .font(DesignTokens.Typography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(DesignTokens.Spacing.medium)
        }
        .background(Colors.groupedBackground)
    }
}
