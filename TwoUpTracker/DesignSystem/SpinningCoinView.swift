import SwiftUI

/// Heads and tails artwork as a single coin, spinning on the Y axis so each face is visible in turn.
struct SpinningCoinView: View {
    private let diameter: CGFloat = 88
    private let speed: Double = 0.45
    private let initialOffset: Double
    private let frontImage: Image
    private let backImage: Image

#if !os(Android)
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
#else
    private var reduceMotion: Bool { false }
#endif
    
    init(frontImage: Image, backImage: Image, initialOffset: Double = 0) {
        self.frontImage = frontImage
        self.backImage = backImage
        self.initialOffset = initialOffset
    }

    var body: some View {
        Group {
            if reduceMotion {
                coinFace(image: frontImage)
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
            coinFace(image: frontImage)
            coinFace(image: backImage)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(tailsOpacity)
        }
        .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
    }

    private func coinFace(image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
    }
}

#if !os(Android)
#Preview("Spinning coin") {
    SpinningCoinView(
        frontImage: Image(systemName: "1.circle.fill"),
        backImage: Image(systemName: "2.circle.fill")
    )
    .padding()
}
#endif
