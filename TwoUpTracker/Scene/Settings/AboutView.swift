import ASKCoordinator
import SwiftUI

// swiftlint:disable line_length
struct AboutView: View {
    let coordinator: Coordinator?

    var body: some View {
        PageLayout {
            HStack(spacing: 0) {
                Button(
                    action: { coordinator?.pop() },
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
                PageHeader(title: "About")
            }
        } content: {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.large) {
                    purposeSection
                    disclaimerSection
                }
                .padding(.horizontal, .margin)
                .padding(.bottom, DesignTokens.Spacing.medium)
            }
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

#Preview {
    AboutView(coordinator: nil)
}
// swiftlint:enable line_length
