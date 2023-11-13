////
////  WordListViewModelTests.swift
////  WordCheckerTests
////
////  Created by Jaewon Yun on 2023/09/12.
////
//
// @testable import iOSCore
// import Domain
// import Testing
// import XCTest
//
// final class WordListViewModelTests: XCTestCase {
//
//    var sut: WordListViewModelProtocol!
//
//    let testMemorizedWordList: [Word] = [
//        .init(word: "F", memorizedState: .memorized),
//        .init(word: "G", memorizedState: .memorized),
//        .init(word: "H", memorizedState: .memorized),
//        .init(word: "I", memorizedState: .memorized),
//    ]
//
//    let testUnmemorizedWordList: [Word] = [
//        .init(word: "A"),
//        .init(word: "B"),
//        .init(word: "C"),
//        .init(word: "D"),
//        .init(word: "E"),
//    ]
//
//    var testAllWordList: [Word] {
//        testMemorizedWordList + testUnmemorizedWordList
//    }
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//
//        let wordUseCase: WordUseCaseFake = makeFilledWordUseCase()
//        sut = WordListViewModel.init(wordUseCase: wordUseCase)
//    }
//
//    override func tearDownWithError() throws {
//        try super.tearDownWithError()
//
//        sut = nil
//    }
//
//    func testShowAllWordListFirst() {
//        // Arrange
//        let actualOutput = Set(sut.wordList)
//        let expectedOutput = Set(testAllWordList)
//
//        // Assert
//        XCTAssertEqual(actualOutput, expectedOutput)
//    }
//
//    func testShowMemorizedList() {
//        // Arrange
//        let expectedOutput = Set(testMemorizedWordList)
//
//        // Act
//        sut.refreshWordList(by: .memorized)
//
//        // Assert
//        XCTAssertEqual(expectedOutput, Set(sut.wordList))
//    }
//
//    func testShowUnmemorizedList() {
//        // Arrange
//        let expectedOutput = Set(testUnmemorizedWordList)
//
//        // Act
//        sut.refreshWordList(by: .unmemorized)
//
//        // Assert
//        XCTAssertEqual(expectedOutput, Set(sut.wordList))
//    }
//
//    func testEditMemorizedWordWhenShowAll() {
//        // Arrange
//        let newWord = "EditedWord"
//        let index = sut.wordList.firstIndex(where: { $0.memorizedState == .memorized })!
//
//        // Act
//        sut.editWord(index: index, newWord: newWord)
//
//        // Assert
//        XCTAssertNotNil(sut.wordList.first { $0.word == "EditedWord" })
//        XCTAssertEqual(sut.wordList.count, testAllWordList.count)
//    }
//
//    func testEditUnmemorizedWordWhenShowAll() {
//        // Arrange
//        let newWord = "EditedWord"
//        let index = sut.wordList.firstIndex(where: { $0.memorizedState == .memorizing })!
//
//        // Act
//        sut.editWord(index: index, newWord: newWord)
//
//        // Assert
//        XCTAssertNotNil(sut.wordList.first { $0.word == "EditedWord" })
//        XCTAssertEqual(sut.wordList.count, testAllWordList.count)
//    }
//
//    func testEditMemorizedWordWhenShowMemorized() {
//        // Arrange
//        sut.refreshWordList(by: .memorized)
//        let newWord = "EditedWord"
//        let index = 2
//
//        // Act
//        sut.editWord(index: index, newWord: newWord)
//
//        // Assert
//        XCTAssertNotNil(sut.wordList.first { $0.word == "EditedWord" })
//        XCTAssertEqual(sut.wordList.count, testMemorizedWordList.count)
//    }
//
//    func testEditUnmemorizedWordWhenShowUnmemorized() {
//        // Arrange
//        sut.refreshWordList(by: .unmemorized)
//        let newWord = "EditedWord"
//        let index = 2
//
//        // Act
//        sut.editWord(index: index, newWord: newWord)
//
//        // Assert
//        XCTAssertNotNil(sut.wordList.first { $0.word == "EditedWord" })
//        XCTAssertEqual(sut.wordList.count, testUnmemorizedWordList.count)
//    }
//
//    func testDeleteMemorizedWordWhenShowAll() {
//        // Arrange
//        let index = sut.wordList.firstIndex(where: { $0.memorizedState == .memorized })!
//
//        // Act
//        sut.deleteWord(index: index)
//
//        // Assert
//        XCTAssertEqual(sut.wordList.count, testAllWordList.count - 1)
//
//        sut.refreshWordList(by: .memorized)
//        let memorizedList = sut.wordList
//        XCTAssertEqual(memorizedList.count, testMemorizedWordList.count - 1)
//
//        sut.refreshWordList(by: .unmemorized)
//        let unmemorizedList = sut.wordList
//        XCTAssertEqual(Set(unmemorizedList), Set(testUnmemorizedWordList))
//    }
//
//    func testDeleteUnmemorizedWordWhenShowAll() {
//        // Arrange
//        let index = sut.wordList.firstIndex(where: { $0.memorizedState == .memorizing })!
//
//        // Act
//        sut.deleteWord(index: index)
//
//        // Assert
//        XCTAssertEqual(sut.wordList.count, testAllWordList.count - 1)
//
//        sut.refreshWordList(by: .memorized)
//        let memorizedList = sut.wordList
//        XCTAssertEqual(Set(memorizedList), Set(testMemorizedWordList))
//
//        sut.refreshWordList(by: .unmemorized)
//        let unmemorizedList = sut.wordList
//        XCTAssertEqual(unmemorizedList.count, testUnmemorizedWordList.count - 1)
//    }
//
// }
//
// MARK: - Helpers
//
// extension WordListViewModelTests {
//
//    func makeFilledWordUseCase() -> WordUseCaseFake {
//        let wordUseCase: WordUseCaseFake = .init()
//
//        wordUseCase._wordList = testAllWordList
//
//        testUnmemorizedWordList.forEach {
//            wordUseCase._unmemorizedWordList.addWord($0)
//        }
//
//        return wordUseCase
//    }
//
// }
