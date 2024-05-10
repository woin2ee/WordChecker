import Foundation
import RxSwift
import RxTest

/// Assert a list of Recorded events has emitted the provided `Void` type elements. This method does not take event times into consideration.
///
/// This assert method convert `Void` type elements to `Boolean` type elements by each.
/// After that, asserts the `stream` array, the `elements` array are equal.
///
/// - Parameters:
///   - stream: Array of recorded events.
///   - elements: Array of expected elements.
public func XCTAssertRecordedElements(
    _ stream: [Recorded<Event<Void>>],
    _ elements: [Void],
    file: StaticString = #file,
    line: UInt = #line
) {
    let equatableStream = stream.map { recorded in
        switch recorded.value {
        case .next:
            return Recorded.next(recorded.time, true)
        case .error(let error):
            return Recorded.error(recorded.time, error)
        case .completed:
            return Recorded.completed(recorded.time)
        }
    }
    
    let equatableElements = elements.map { true }

    XCTAssertRecordedElements(
        equatableStream,
        equatableElements,
        file: file,
        line: line
    )
}
