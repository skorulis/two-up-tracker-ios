import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    @FocusState var lossLimitFocused: Bool
    @State var showResetConfirmation = false

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
                    .font(DesignTokens.Typography.body.skip_monospacedDigit())
                    .focused($lossLimitFocused)
            } header: {
                Text("Loss limit")
            } footer: {
                Text(
                    "Set the point where it's time to call it a day"
                )
                .font(DesignTokens.Typography.caption)
            }

            about
            debug

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

    private var about: some View {
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

    private var debug: some View {
        #if DEBUG
        Section {
            Button {
                viewModel.configureScreenshotData()
            } label: {
                Text("Setup app for screenshots")
            }
        } header: {
            Text("Debug")
        }
        #else
        EmptyView()
        #endif
    }
}
