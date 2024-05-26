@testable import Domain_WordMemorization
import Foundation
import XCTest

final class DefaultWordMemorizationServiceTests: XCTestCase {

    var subject: DefaultWordMemorizationService!
    
    override func setUp() {
        subject = DefaultWordMemorizationService()
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func test_count() {
        // Given
        let wordList: [Word] = [
            try! Word(id: UUID(), word: "A", isChecked: false),
            try! Word(id: UUID(), word: "B", isChecked: true),
            try! Word(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        
        // When & Then
        XCTAssertEqual(subject.count, wordList.count)
        XCTAssertEqual(subject.unCheckedCount, 2)
        XCTAssertEqual(subject.checkedCount, 1)
    }
    
    func test_shuffleList_whenCountIsGreaterThan1() {
        // Given
        let wordList: [Word] = [
            try! Word(id: UUID(), word: "1", isChecked: false),
            try! Word(id: UUID(), word: "2", isChecked: false),
        ]
        subject.setList(wordList)
        let current = subject.current
        
        // Ghen
        subject.shuffleList()
        
        // Then
        XCTAssertNotEqual(current, subject.current)
    }
    
    func test_shuffleList_whenOnly1Word() {
        // Given
        let wordList: [Word] = [
            try! Word(id: UUID(), word: "1", isChecked: false),
        ]
        subject.setList(wordList)
        let current = subject.current
        
        // Ghen
        subject.shuffleList()
        
        // Then
        XCTAssertEqual(current, subject.current)
    }
    
    func test_nextAndPrevious() {
        // Given
        let wordList: [Word] = [
            try! Word(id: UUID(), word: "A", isChecked: false),
            try! Word(id: UUID(), word: "B", isChecked: false),
            try! Word(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        
        // When
        let current = subject.current
        let previous1 = subject.previous()
        let next1 = subject.next()
        let next2 = subject.next()
        let previous2 = subject.previous()
        let next3 = subject.next()
        let next4 = subject.next()
        
        // Then
        XCTAssertEqual(current?.word, "A")
        XCTAssertEqual(current?.isChecked, false)
        XCTAssertEqual(previous1?.word, nil)
        XCTAssertEqual(next1?.word, "B")
        XCTAssertEqual(next2?.word, "C")
        XCTAssertEqual(next2?.isChecked, false)
        XCTAssertEqual(previous2?.word, "B")
        XCTAssertEqual(previous2?.isChecked, true)
        XCTAssertEqual(next3?.word, "C")
        XCTAssertEqual(next3?.isChecked, false)
        XCTAssertEqual(next4?.word, nil)
        XCTAssertEqual(subject.current?.isChecked, true)
        XCTAssertTrue(subject.isCompletedAllChecking)
    }
    
    func test_next_whenEmptyList() {
        subject.setList([])
        XCTAssertNil(subject.next())
    }
    
    func test_previous_whenEmptyList() {
        subject.setList([])
        XCTAssertNil(subject.previous())
    }
    
    func test_deleteCurrent() {
        // Given
        let wordList: [Word] = [
            try! Word(id: UUID(), word: "A", isChecked: false),
            try! Word(id: UUID(), word: "B", isChecked: false),
            try! Word(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        let current = subject.current
        
        // When
        subject.deleteCurrent()
        
        // Then
        XCTAssertNotEqual(current, subject.current)
        XCTAssertEqual(subject.count, 2)
    }
    
    func test_deleteCurrent_whenEmptyList() {
        // Given
        let wordList: [Word] = [
        ]
        subject.setList(wordList)
        
        // When
        subject.deleteCurrent()
        
        // Then
        XCTAssertEqual(subject.currentIndex, .undefined)
        XCTAssertEqual(subject.current, nil)
    }
    
    func test_deleteCurrent_whenOnly1Word() {
        // Given
        let wordList: [Word] = [
            try! Word(id: UUID(), word: "A", isChecked: false),
        ]
        subject.setList(wordList)
        
        // When
        subject.deleteCurrent()
        
        // Then
        XCTAssertEqual(subject.currentIndex, .undefined)
        XCTAssertEqual(subject.current, nil)
        XCTAssertEqual(subject.wordList, [])
    }
    
    func test_deleteCurrent_whenIsCompletedAllChecking() {
        // Given
        let wordList: [Word] = [
            try! Word(id: UUID(), word: "A", isChecked: false),
            try! Word(id: UUID(), word: "B", isChecked: false),
        ]
        subject.setList(wordList)
        subject.next()
        subject.next()
        
        // When
        subject.deleteCurrent()
        
        // Then
        XCTAssertTrue(subject.isCompletedAllChecking)
        XCTAssertEqual(subject.current, subject.wordList.last)
    }
    
    func test_turnToUnChecked_whenShuffle() {
        // Given
        let wordList: [Word] = [
            try! Word(id: UUID(), word: "A", isChecked: true),
            try! Word(id: UUID(), word: "B", isChecked: true),
            try! Word(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        
        // When
        subject.shuffleList()
        
        // Then
        XCTAssertEqual(subject.unCheckedCount, 3)
    }
}
