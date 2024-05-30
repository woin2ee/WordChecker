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
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: true),
            try! MemorizingWord(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        
        // When & Then
        XCTAssertEqual(subject.count, wordList.count)
        XCTAssertEqual(subject.unCheckedCount, 3)
    }
    
    func test_shuffleList_whenCountIsGreaterThan1() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "1", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "2", isChecked: false),
        ]
        subject.setList(wordList)
        let current = subject.current
        
        // When
        subject.shuffleList()
        
        // Then
        XCTAssertNotEqual(current, subject.current)
    }
    
    func test_shuffleList_whenOnly1Word() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "1", isChecked: false),
        ]
        subject.setList(wordList)
        let current = subject.current
        
        // When
        subject.shuffleList()
        
        // Then
        XCTAssertEqual(current, subject.current)
    }
    
    func test_shuffleList_whenCompletedChecking() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "1", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "2", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "3", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        subject.next()
        subject.next()
        subject.next()
        XCTAssertEqual(subject.current?.word, "3")
        
        // When
        subject.shuffleList()
        
        // Then
        XCTAssertNotEqual(subject.current?.word, "3")
        XCTAssertEqual(subject._currentIndex.rawValue, 0)
    }
    
    func test_shuffleList_whenEmptyList() {
        // Given
        subject.setList([])
        
        // When
        subject.shuffleList()
        
        // Then
        XCTAssertNil(subject.current)
        XCTAssertEqual(subject._currentIndex, .undefined)
    }
    
//    func test_shuffleList_whenEmptyList() {
//        // Given
//        subject.setList([])
//        
//        // When
//        subject.shuffleList()
//        
//        // Then
//        XCTAssertNil(subject.current)
//        XCTAssertEqual(subject.currentIndex, .undefined)
//    }
    
    func test_nextAndPrevious() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "C", isChecked: false),
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
    
    func test_previous_whenIsCompletedAllChecking() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        subject.next()
        subject.next()
        subject.next()
        
        // When
        subject.previous()
        
        // Then
        XCTAssertEqual(subject.current?.word, "B")
        XCTAssertEqual(subject._currentIndex.rawValue, 1)
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
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "C", isChecked: false),
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
        let wordList: [MemorizingWord] = [
        ]
        subject.setList(wordList)
        
        // When
        subject.deleteCurrent()
        
        // Then
        XCTAssertEqual(subject._currentIndex, .undefined)
        XCTAssertEqual(subject.current, nil)
    }
    
    func test_deleteCurrent_whenOnly1Word() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
        ]
        subject.setList(wordList)
        
        // When
        subject.deleteCurrent()
        
        // Then
        XCTAssertEqual(subject._currentIndex, .undefined)
        XCTAssertEqual(subject.current, nil)
        XCTAssertEqual(subject.wordList, [])
    }
    
    func test_deleteCurrent_whenIsCompletedAllChecking() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: false),
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
    
    
    func test_deleteWord_whenRightAfterShuffle() {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: id1, word: "A", isChecked: false),
            try! MemorizingWord(id: id2, word: "B", isChecked: false),
            try! MemorizingWord(id: id3, word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        subject.shuffleList()
        
        // When
        subject.deleteWord(by: id2)
        
        // Then
        XCTAssertEqual(subject.count, 2)
    }
    
    func test_deleteWord_whenOnly1Word() {
        // Given
        let id1 = UUID()
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: id1, word: "A", isChecked: false),
        ]
        subject.setList(wordList)
        
        // When
        subject.deleteWord(by: id1)
        
        // Then
        XCTAssertEqual(subject.count, 0)
        XCTAssertEqual(subject._currentIndex, .undefined)
    }
    
    func test_deleteUncheckedWord_whileMemorizing() {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: id1, word: "A", isChecked: false),
            try! MemorizingWord(id: id2, word: "B", isChecked: false),
            try! MemorizingWord(id: id3, word: "C", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        subject.next()
        subject.next()
        
        // When
        subject.deleteWord(by: id3)
        
        // Then
        XCTAssertEqual(subject.unCheckedCount, 0)
        XCTAssertTrue(subject.isCompletedAllChecking)
        XCTAssertEqual(subject.current?.word, "B")
    }
    
    func test_deleteCheckedWord_whileMemorizing() {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: id1, word: "A", isChecked: false),
            try! MemorizingWord(id: id2, word: "B", isChecked: false),
            try! MemorizingWord(id: id3, word: "C", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        subject.next()
        subject.next()
        
        // When
        subject.deleteWord(by: id1)
        
        // Then
        XCTAssertEqual(subject.checkedCount, 1)
        XCTAssertEqual(subject.current?.word, "C")
        XCTAssertEqual(subject._currentIndex.rawValue, 1)
    }
    
    func test_deleteCheckedWord_whileMemorizing_with1Previous() {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: id1, word: "A", isChecked: false),
            try! MemorizingWord(id: id2, word: "B", isChecked: false),
            try! MemorizingWord(id: id3, word: "C", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        subject.next()
        subject.next()
        subject.previous()
        
        // When
        subject.deleteWord(by: id2)
        
        // Then
        XCTAssertEqual(subject.checkedCount, 1)
        XCTAssertEqual(subject.current?.word, "C")
        XCTAssertEqual(subject._currentIndex.rawValue, 1)
    }
    
    func test_deleteCheckedWord_whileMemorizing_with2Previous() {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: id1, word: "A", isChecked: false),
            try! MemorizingWord(id: id2, word: "B", isChecked: false),
            try! MemorizingWord(id: id3, word: "C", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        subject.next()
        subject.next()
        subject.previous()
        subject.previous()
        
        // When
        subject.deleteWord(by: id2)
        
        // Then
        XCTAssertEqual(subject.checkedCount, 1)
        XCTAssertEqual(subject.current?.word, "A")
        XCTAssertEqual(subject._currentIndex.rawValue, 0)
    }
    
    func test_deleteCheckedWord_whenIsCompletedAllChecking() {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: id1, word: "A", isChecked: false),
            try! MemorizingWord(id: id2, word: "B", isChecked: false),
            try! MemorizingWord(id: id3, word: "C", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        subject.next()
        subject.next()
        subject.next()
        subject.previous()
        
        // When
        subject.deleteWord(by: id2)
        
        // Then
        XCTAssertTrue(subject.isCompletedAllChecking)
        XCTAssertEqual(subject.current?.word, "C")
        XCTAssertEqual(subject._currentIndex.rawValue, 1)
    }
    
    func test_turnToUnChecked_whenShuffle() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: true),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: true),
            try! MemorizingWord(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        
        // When
        subject.shuffleList()
        
        // Then
        XCTAssertEqual(subject.unCheckedCount, 3)
    }
    
    func test_append_whileMemorizing() throws {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: false),
        ]
        subject.setList(wordList, shuffled: false)
        
        // When & Then
        subject.next()
        subject.next()
        XCTAssertTrue(subject.isCompletedAllChecking)
        try subject.appendWord("C", with: UUID())
        subject.next()
        XCTAssertEqual(subject.current?.word, "C")
        XCTAssertFalse(subject.isCompletedAllChecking)
        XCTAssertEqual(subject.unCheckedCount, 1)
    }
    
    func test_append_whenEmptyList() throws {
        // Given
        subject.setList([])
        
        // When & Then
        try subject.appendWord("A", with: UUID())
        XCTAssertEqual(subject.current?.word, "A")
        XCTAssertFalse(subject.isCompletedAllChecking)
        XCTAssertEqual(subject.unCheckedCount, 1)
        
        XCTAssertNil(subject.next())
        XCTAssertTrue(subject.isCompletedAllChecking)
        XCTAssertEqual(subject.unCheckedCount, 0)
    }
    
    func test_insert_whenEmptyList() throws {
        // Given
        subject.setList([])
        
        // When
        try subject.insertWord("A", with: UUID())
        
        // Then
        XCTAssertEqual(subject.current?.word, "A")
        XCTAssertEqual(subject._currentIndex.rawValue, 0)
    }
    
    func test_insert_whileMemorizing() throws {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        subject.next()
        
        // When
        try subject.insertWord("E", with: UUID())
        
        // Then
        let insertedIndex = subject.wordList.firstIndex(where: { $0.word == "E" })
        XCTAssertGreaterThan(insertedIndex!, subject._currentIndex.rawValue)
    }
    
    func test_updateWord() {
        // Given
        let id = UUID()
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: false),
            try! MemorizingWord(id: id, word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        
        // When
        subject.updateWord(to: "Update", with: id)
        
        // Then
        XCTAssertTrue(subject.wordList.contains(where: { $0.word == "Update" }))
        XCTAssertFalse(subject.wordList.contains(where: { $0.word == "C" }))
        XCTAssertEqual(subject.count, 3)
    }
    
    func test_currentIndex() {
        // Given
        let wordList: [MemorizingWord] = [
            try! MemorizingWord(id: UUID(), word: "A", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "B", isChecked: false),
            try! MemorizingWord(id: UUID(), word: "C", isChecked: false),
        ]
        subject.setList(wordList)
        subject.next()
        subject.next()
        
        // When & Then
        XCTAssertEqual(subject.currentIndex, 2)
    }
    
    func test_currentIndex_whenEmptyList() {
        // Given
        subject.setList([])
        subject.next()
        subject.next()
        
        // When & Then
        XCTAssertNil(subject.currentIndex)
    }
}
