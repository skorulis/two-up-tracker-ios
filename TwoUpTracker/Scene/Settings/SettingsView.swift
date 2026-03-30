import SwiftUI

struct SettingsView: View {
    @Bindable var model: SettingsViewModel
    @FocusState private var lossLimitFocused: Bool
    @State private var showResetConfirmation = false

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
                    NavigationLink {
                        WhatIsTwoUpView()
                    } label: {
                        Text("What is Two-Up?")
                    }
                } header: {
                    Text("About")
                } footer: {
                    Text("Learn the rules, terminology, and history.")
                        .font(DesignTokens.Typography.caption)
                }
            }
            .alert("Reset all data?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    model.resetAllData()
                }
            } message: {
                Text("This will delete your current session and restore default settings.")
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
