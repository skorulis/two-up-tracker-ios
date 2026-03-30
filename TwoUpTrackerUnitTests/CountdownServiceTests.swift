import XCTest
@testable import TwoUpTracker

@MainActor
final class CountdownServiceTests: XCTestCase {

    func testListenerCalledWhenCountdownAlreadyFinished() {
        let fixedNow = Date()
        let sut = CountdownService(nowProvider: { fixedNow })
        var callCount = 0

        sut.startCountdown(to: fixedNow.addingTimeInterval(-1))
        sut.addFinishListener {
            callCount += 1
        }

        XCTAssertEqual(callCount, 1)
        XCTAssertTrue(sut.isFinished)
        XCTAssertEqual(sut.remainingTime, 0)
    }

    func testRemoveListenerPreventsCallback() {
        let fixedNow = Date()
        let sut = CountdownService(nowProvider: { fixedNow })
        var callCount = 0

        let listenerID = sut.addFinishListener {
            callCount += 1
        }
        sut.removeFinishListener(listenerID)
        sut.startCountdown(to: fixedNow.addingTimeInterval(-1))

        XCTAssertEqual(callCount, 0)
        XCTAssertTrue(sut.isFinished)
    }
}
