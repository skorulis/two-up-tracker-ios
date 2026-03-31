import Charts
import SwiftUI

struct GraphView: View {
    @State var viewModel: GraphViewModel

    var body: some View {
        NavigationStack {
            PageLayout {
                PageHeader(title: viewModel.session.name)
            } content: {
                if viewModel.session.hasGraphData {
                    scrollContent
                } else {
                    EmptyState(
                        title: "No data yet",
                        message:
                            "Add rounds from the Bets tab and record outcomes in History "
                            + "to see your running balance.",
                        systemImage: "chart.line.uptrend.xyaxis"
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .id(viewModel.mainStore.activeSession.rounds.count)
        }
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                Card {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                        ratioRow(
                            title: "Win percentage",
                            value: viewModel.session.winPercentageText,
                            detail: viewModel.session.winLossRecordText
                        )
                        ratioRow(
                            title: "Heads vs tails",
                            value: viewModel.session.headsTailsPercentageText,
                            detail: nil
                        )
                    }
                }

                Card {
                    chart
                        .frame(minHeight: 260)
                }
            }
            .padding(.horizontal, .margin)
        }
    }

    private func ratioRow(title: String, value: String, detail: String?) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(value)
                    .font(DesignTokens.Typography.statValue)
            }
            if let detail, !detail.isEmpty {
                Text(detail)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var chart: some View {
        Chart {
            ForEach(viewModel.session.balanceSeries) { point in
                LineMark(
                    x: .value("Time", point.date),
                    y: .value("Balance", point.balance)
                )
                .interpolationMethod(.linear)
                .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .foregroundStyle(Color.accentColor)
            }
        }
        .chartXAxisLabel("Time", alignment: .trailing)
        .chartYAxisLabel("Balance", alignment: .leading)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                        Text(amount, format: Formatters.roundedCurrencyDisplayFormat)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: min(viewModel.session.balanceSeries.count, 12))) { _ in
                AxisGridLine()
            }
        }
        .accessibilityLabel("Running balance over time")
        .accessibilityHint("Line chart of cumulative profit or loss after each resolved round.")
        .animation(.smooth(duration: 0.35), value: viewModel.mainStore.activeSession.rounds.count)
    }
}
