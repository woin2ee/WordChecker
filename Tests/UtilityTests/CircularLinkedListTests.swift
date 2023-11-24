//
//  CircularLinkedListTests.swift
//  WordCheckerTests
//
//  Created by Jaewon Yun on 2023/09/10.
//

@testable import Utility
import XCTest

final class CircularLinkedListTests: XCTestCase {

    var sut: CircularLinkedList<Int>!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .init()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func testNext() {
        // Arrange
        sut.append(contentsOf: [1, 2, 3, 4])
        let current = sut.current
        var nextItems: [Int?] = []

        // Act
        for _ in 0..<3 {
            nextItems.append(sut.next())
        }
        sut.next()

        // Assert
        nextItems.forEach {
            XCTAssertNotEqual($0, current)
        }
        XCTAssertEqual(sut.current, current)
    }

    func testPrevious() {
        // Arrange
        sut.append(contentsOf: [1, 2, 3, 4])
        let current = sut.current
        var previousItems: [Int?] = []

        // Act
        for _ in 0..<3 {
            previousItems.append(sut.previous())
        }
        sut.previous()

        // Assert
        previousItems.forEach {
            XCTAssertNotEqual($0, current)
        }
        XCTAssertEqual(sut.current, current)
    }

    func testRemoveCurrentIndex() {
        // Arrange
        sut.append(contentsOf: [1, 2, 3, 4])
        let current = sut.current!

        // Act
        sut.remove(at: sut.currentIndex)

        // Assert
        XCTAssertFalse(sut.elements.contains(current))
    }

    func testRemoveCurrentIndexWhenLast() {
        // Arrange
        sut.append(contentsOf: [1, 2, 3, 4])
        (0..<3).forEach { _ in sut.next() }

        // Act
        sut.remove(at: sut.currentIndex)

        // Assert
        XCTAssertNotNil(sut.current)
    }

}
