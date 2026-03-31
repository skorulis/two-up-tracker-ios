import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    @FocusState private var lossLimitFocused: Bool
    @State private var showResetConfirmation = false

    var body: some View {
        PageLayout {
            PageHeader(title: "Settings")
        } content: {
            content
        }
        .alert("Reset all data?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                viewModel.resetAllData()
            }
        } message: {
            Text("This will delete your current session and restore default settings.")
        }
        .onAppear {
            viewModel.syncFromStore()
        }
        .onChange(of: lossLimitFocused) { wasFocused, isFocused in
            if wasFocused, !isFocused {
                viewModel.applyLossLimitFromField()
            }
        }
    }

    private var content: some View {
        Form {
            Section {
                TextField("Amount", text: $viewModel.lossLimitText)
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

            Section {
                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {
                    Text("Reset all data")
                }
            } footer: {
                Text("Clears your session and loss limit. This cannot be undone.")
                    .font(DesignTokens.Typography.caption)
            }

            Section {
                Button {
                    viewModel.showAbout()
                } label: {
                    HStack {
                        Text("About this app")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                }

                Button {
                    viewModel.showWhatIsTwoUp()
                } label: {
                    HStack {
                        Text("What is Two-up?")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
            } header: {
                Text("About")
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .modifier(
            KeyboardToolbarModifier {
                HStack {
                    Spacer()
                    Button("Done") {
                        lossLimitFocused = false
                    }
                }
                .padding(.horizontal, .margin)
                .padding(.bottom, 8)
            }
        )
    }
}
