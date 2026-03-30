import Charts
import SwiftUI

struct GraphView: View {
    @State var model: GraphViewModel

    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }

    var body: some View {
        NavigationStack {
            PageLayout {
                PageHeader(title: model.sessionName)
            } content: {
                if model.hasData {
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
            .id(model.mainStore.activeSession.rounds.count)
        }
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                Card {
                    HStack {
                        Text("Running balance")
                            .font(DesignTokens.Typography.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        CurrencyLabel(amount: model.currentBalance)
                    }
                }

                Card {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                        ratioRow(
                            title: "Win percentage",
                            value: model.winPercentageText,
                            detail: model.winLossRecordText
                        )
                        ratioRow(
                            title: "Heads vs tails",
                            value: model.headsTailsPercentageText,
                            detail: nil
                        )
                    }
                }

                Card {
                    chart
                        .frame(minHeight: 260)
                }
            }
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
            ForEach(model.balanceSeries) { point in
                LineMark(
                    x: .value("Time", point.date),
                    y: .value("Balance", point.balance)
                )
                .interpolationMethod(.catmullRom)
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
                        Text(amount, format: .currency(code: currencyCode))
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: min(model.balanceSeries.count, 12))) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(date, format: .dateTime.month(.abbreviated).day().hour().minute())
                    }
                }
            }
        }
        .accessibilityLabel("Running balance over time")
        .accessibilityHint("Line chart of cumulative profit or loss after each resolved round.")
        .animation(.smooth(duration: 0.35), value: model.mainStore.activeSession.rounds.count)
    }
}
