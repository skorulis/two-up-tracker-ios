//  Created by Alex Skorulis on 2/4/2026.

import Foundation
import SwiftUI

extension View {
    func skip_contentShape<S: Shape>(_ shape: S) -> some View {
        #if !os(Android)
        return contentShape(shape)
        #else
        return self
        #endif
    }

    nonisolated public func skip_accessibilityElement(children: AccessibilityChildBehavior = .ignore) -> some View {
        #if !os(Android)
        return accessibilityElement(children: children)
        #else
        return self
        #endif
    }

    nonisolated public func skip_accessibilityLabel(_ labelKey: LocalizedStringKey) -> some View {
        #if !os(Android)
            return accessibilityLabel(labelKey)
        #else
        return self
        #endif
    }

    nonisolated public func skip_accessibilityLabel<S: StringProtocol>(_ label: S) -> some View {
        #if !os(Android)
            return accessibilityLabel(label)
        #else
        return self
        #endif
    }
}

extension Font {
    nonisolated public func skip_monospacedDigit() -> Font {
        #if !os(Android)
            return monospacedDigit()
        #else
        return self
        #endif
    }
}
