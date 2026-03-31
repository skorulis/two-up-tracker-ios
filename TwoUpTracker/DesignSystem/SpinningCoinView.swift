import SwiftUI

/// Heads and tails artwork as a single coin, spinning on the Y axis so each face is visible in turn.
struct SpinningCoinView: View {
    var diameter: CGFloat = 88
    /// Full rotations per second.
    var speed: Double = 0.45

    var initialOffset: Double = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            if reduceMotion {
                coinFace(asset: Asset.heads)
            } else {
                TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: false)) { context in
                    let t = context.date.timeIntervalSinceReferenceDate
                    let degrees = (t * speed * 360).truncatingRemainder(dividingBy: 360) + initialOffset
                    spinningCoin(angle: degrees)
                }
            }
        }
        .accessibilityHidden(true)
    }

    private func spinningCoin(angle: Double) -> some View {
        // ZStack ignores real depth ordering during 3D rotation, so the later subview can cover the
        // first for every frame. Fade by which face points toward the camera (cosine of Y rotation).
        let radians = angle * .pi / 180
        let tailsOpacity = max(0, -cos(radians))

        return ZStack {
            coinFace(asset: Asset.heads)
            coinFace(asset: Asset.tails)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(tailsOpacity)
        }
        .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
    }

    private func coinFace(asset: ImageAsset) -> some View {
        Image(asset: asset)
            .resizable()
            .scaledToFill()
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
    }
}

#Preview("Spinning coin") {
    SpinningCoinView()
        .padding()
}
