import ASKCoordinator
import SwiftUI

// swiftlint:disable line_length
struct AboutView: View {
    private let amplitudePrivacyURL = URL(string: "https://amplitude.com/privacy")!

    let coordinator: Coordinator?

    var body: some View {
        content
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About")
                        .font(DesignTokens.Typography.display)
                }
            }
    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.large) {
                purposeSection
                privacyPolicySection
                disclaimerSection
            }
            .padding(.horizontal, .margin)
            .padding(.bottom, DesignTokens.Spacing.medium)
        }
    }

    private var purposeSection: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "What this app does")
                Text(
                    "Two Up Tracker helps you keep records of sessions and bets so you can monitor your results."
                )
                .font(DesignTokens.Typography.body)

                Text(
                    "This app does not place, broker, or process bets of any kind. It is a tracking tool only."
                )
                .font(DesignTokens.Typography.body)
            }
        }
    }

    private var privacyPolicySection: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "Privacy policy")
                Text(
                    "Two Up Tracker does not use accounts. The session and bet information you enter is stored on " +
                        "your device only and is not uploaded to our servers."
                )
                .font(DesignTokens.Typography.body)

                Text(
                    "We use Amplitude, a third-party analytics service, to understand how the app is used—for " +
                        "example which areas of the app are viewed and coarse interaction events. These analytics events do not include the amounts or other details you enter for your bets."
                )
                .font(DesignTokens.Typography.body)

                Text(
                    "Analytics data may be processed and stored outside Australia, including in the United States."
                )
                .font(DesignTokens.Typography.body)

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("For how Amplitude handles data, see their privacy policy:")
                        .font(DesignTokens.Typography.body)
                    Link("Amplitude privacy policy", destination: amplitudePrivacyURL)
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var disclaimerSection: some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                SectionHeader(title: "Legal disclaimer")
                Text("1. No Financial Advice: ").bold() +
                Text("This app, TwoUpTracker, is a tracking tool intended for personal information and informational purposes only. It does not constitute financial, legal, or tax advice. The information presented does not take into account your personal financial situation, objectives, or needs.")

                Text("2. Accuracy of Data: ").bold() +
                Text("While we aim for accuracy, TwoUpTracker does not warrant that the information, including wins and losses, is correct, complete, or up-to-date. Users are responsible for verifying their own gambling records.")

                Text("3. Limitation of Liability: ").bold() +
                Text("To the maximum extent permitted by law, TwoUpTracker and its affiliates are not liable for any losses, damages, or expenses incurred by users, including any financial losses resulting from gambling activities tracked by this app.")

                responsibleGamblingParagraph

                Text("5. Not a Betting Operator: ").bold() +
                Text("This app is not an online gambling provider, bookmaker, or financial institution.")

            }
            .font(DesignTokens.Typography.body)
        }
    }

    private var responsibleGamblingParagraph: some View {
        Text(Self.responsibleGamblingAttributed)
    }

    private static var responsibleGamblingAttributed: AttributedString {
        let markdown =
            "**4. Responsible Gambling:** Gambling involves risk. Only gamble with money you can afford to lose. " +
            "If you feel that gambling is causing problems, support is available. You can call " +
            "[1800 858 858](tel:1800858858) or visit [gamblinghelponline.org.au](https://gamblinghelponline.org.au)."
        return (try? AttributedString(markdown: markdown)) ?? AttributedString(markdown)
    }
}

#if !os(Android)
#Preview {
    AboutView(coordinator: nil)
}
#endif
// swiftlint:enable line_length
