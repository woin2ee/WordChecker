//
//  DefaultWordServiceTests.swift
//  Domain_WordTests
//
//  Created by Jaewon Yun on 3/29/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import Domain_Word
import Domain_WordTesting

import XCTest

final class DefaultWordServiceTests: XCTestCase {
    
    var sut: DefaultWordService!
    var wordRepositoryFake: WordRepositoryFake!
    var unmemorizedWordListRepository: UnmemorizedWordListRepository!

    override func setUpWithError() throws {
        wordRepositoryFake = .init()
        unmemorizedWordListRepository = .init()
        sut = .init(
            wordRepository: wordRepositoryFake,
            unmemorizedWordListRepository: unmemorizedWordListRepository,
            wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepositoryFake)
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        wordRepositoryFake = nil
        unmemorizedWordListRepository = nil
    }
    
    func test_updateWordToMemorizedStateSuccess() throws {
        // Given
        let uuid = UUID()
        let originWord = try Word(uuid: uuid, word: "OriginWord", memorizedState: .memorizing)
        wordRepositoryFake.save(originWord)
        unmemorizedWordListRepository.addWord(originWord)
        
        // When
        let newAttribute = WordAttribute(word: "NewWord", memorizationState: .memorized)
        try sut.updateWord(with: newAttribute, id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)!
        XCTAssertEqual(newWord.word, newAttribute.word)
        XCTAssertEqual(newWord.memorizedState, newAttribute.memorizationState)
        XCTAssertEqual(unmemorizedWordListRepository.unmemorizedWordList.count, 0)
    }
    
    func test_updateWordToMemorizingStateSuccess() throws {
        // Given
        let uuid = UUID()
        let originWord = try Word(uuid: uuid, word: "OriginWord", memorizedState: .memorized)
        wordRepositoryFake.save(originWord)
        
        // When
        let newAttribute = WordAttribute(word: "NewWord", memorizationState: .memorizing)
        try sut.updateWord(with: newAttribute, id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)!
        XCTAssertEqual(newWord.word, newAttribute.word)
        XCTAssertEqual(newWord.memorizedState, newAttribute.memorizationState)
        XCTAssertEqual(unmemorizedWordListRepository.unmemorizedWordList.count, 1)
    }
    
    func test_updateWordSuccess_whenDuplicateWord() throws {
        // Given
        let uuid = UUID()
        let originWord = try Word(uuid: uuid, word: "OriginWord", memorizedState: .memorizing)
        wordRepositoryFake.save(originWord)
        
        // When
        let newAttribute = WordAttribute(word: "OriginWord", memorizationState: .memorized)
        try sut.updateWord(with: newAttribute, id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)!
        XCTAssertEqual(newWord.word, newAttribute.word)
        XCTAssertEqual(newWord.memorizedState, newAttribute.memorizationState)
    }
    
    func test_updateWordFailure_whenInvalidWord() throws {
        // Given
        let uuid = UUID()
        let originWord = try Word(uuid: uuid, word: "OriginWord", memorizedState: .memorizing)
        wordRepositoryFake.save(originWord)
        
        // When
        let newAttribute = WordAttribute(word: "", memorizationState: .memorized)
        XCTAssertThrowsError(try sut.updateWord(with: newAttribute, id: uuid))
        
        // Then
        XCTAssertEqual(sut.fetchWord(by: uuid), originWord)
    }
    
    func test_updateWordOnly() throws {
        // Given
        let uuid = UUID()
        let word = try Word(uuid: uuid, word: "Word", memorizedState: .memorizing)
        wordRepositoryFake.save(word)
        unmemorizedWordListRepository.addWord(word)
        
        // When
        try sut.updateWord(with: WordAttribute(word: "UpdatedWord"), id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)
        XCTAssertEqual(newWord?.word, "UpdatedWord")
        XCTAssertEqual(newWord?.memorizedState, .memorizing)
        XCTAssertEqual(unmemorizedWordListRepository.getCurrentWord()?.word, "UpdatedWord")
    }
    
    func test_updateMemorizationStateOnly() throws {
        // Given
        let uuid = UUID()
        let word = try Word(uuid: uuid, word: "Word", memorizedState: .memorizing)
        wordRepositoryFake.save(word)
        unmemorizedWordListRepository.addWord(word)
        
        // When
        try sut.updateWord(with: WordAttribute(memorizationState: .memorized), id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)
        XCTAssertEqual(newWord?.word, "Word")
        XCTAssertEqual(newWord?.memorizedState, .memorized)
        XCTAssertNil(unmemorizedWordListRepository.getCurrentWord())
    }
}
