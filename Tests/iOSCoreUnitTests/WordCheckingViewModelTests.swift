//
//  WordCheckingViewModelTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import iOSCore
import Combine
import Testing
import XCTest

final class WordCheckingViewModelTests: XCTestCase {

    var sut: WordCheckingViewModelProtocol!

    var store: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let wordUseCase: WordUseCaseFake = .init()

        sut = WordCheckingViewModel.init(
            wordUseCase: wordUseCase,
            state: wordUseCase._unmemorizedWordList,
            delegate: DelegateStub()
        )
        store = .init()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
        store = nil
    }

    func testAddWordWhenNoWords() {
        // Arrange
        var currentWord: String?
        sut.currentWord
            .sink {
                currentWord = $0
            }
            .store(in: &store)

        // Act
        sut.addWord("Test")

        // Assert
        XCTAssertEqual(currentWord, "Test")
    }

    func testDeleteLastWord() {
        // Arrange
        var currentWord: String?
        sut.currentWord
            .sink {
                currentWord = $0
            }
            .store(in: &store)

        sut.addWord("Test")

        // Act
        sut.deleteCurrentWord()

        // Assert
        XCTAssertNil(currentWord)
    }

    func testMartAsMemorizedLastWord() {
        // Arrange
        var currentWord: String? = "nil"
        sut.currentWord
            .sink {
                currentWord = $0
            }
            .store(in: &store)

        sut.addWord("Test")

        // Act
        sut.markCurrentWordAsMemorized()

        // Assert
        XCTAssertNil(currentWord)
    }

}
