//  Created by Alex Skorulis on 1/4/2026.

import Foundation
import SwiftUI

struct KeyboardToolbarModifier<Toolbar: View>: ViewModifier {
    @State private var isKeyboardShown = false
    private let toolbar: Toolbar

    init(@ViewBuilder toolbar: () -> Toolbar) {
        self.toolbar = toolbar()
    }

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                if isKeyboardShown {
                    toolbar
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                withAnimation(.easeInOut.delay(0.15)) {
                    isKeyboardShown = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                isKeyboardShown = false
            }
    }
}
