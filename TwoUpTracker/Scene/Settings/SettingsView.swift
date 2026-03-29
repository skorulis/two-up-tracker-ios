import SwiftUI

struct SettingsView: View {
    @Bindable var model: SettingsViewModel
    @FocusState private var lossLimitFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", text: $model.lossLimitText)
                        .keyboardType(.decimalPad)
                        .font(DesignTokens.Typography.body.monospacedDigit())
                        .focused($lossLimitFocused)
                } header: {
                    Text("Loss limit")
                } footer: {
                    Text(
                        "Set the point where it's time to call it a day"
                    )
                    .font(DesignTokens.Typography.caption)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        lossLimitFocused = false
                    }
                }
            }
            .onAppear {
                model.syncFromStore()
            }
            .onChange(of: lossLimitFocused) { wasFocused, isFocused in
                if wasFocused, !isFocused {
                    model.applyLossLimitFromField()
                }
            }
        }
    }
}
