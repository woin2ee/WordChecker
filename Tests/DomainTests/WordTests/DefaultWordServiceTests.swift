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
    var fakeWordRepository: FakeWordRepository!
    var unmemorizedWordListRepository: UnmemorizedWordListRepository!

    override func setUpWithError() throws {
        fakeWordRepository = .init()
        unmemorizedWordListRepository = .init()
        sut = .init(
            wordRepository: fakeWordRepository,
            unmemorizedWordListRepository: unmemorizedWordListRepository,
            wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: fakeWordRepository)
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        fakeWordRepository = nil
        unmemorizedWordListRepository = nil
    }
    
    func test_updateWordToMemorizationStateSuccess() throws {
        // Given
        let uuid = UUID()
        let originWord = try Word(uuid: uuid, word: "OriginWord", memorizationState: .memorizing)
        fakeWordRepository.save(originWord)
        unmemorizedWordListRepository.addWord(originWord)
        
        // When
        let newAttribute = WordAttribute(word: "NewWord", memorizationState: .memorized)
        try sut.updateWord(with: newAttribute, id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)!
        XCTAssertEqual(newWord.word, newAttribute.word)
        XCTAssertEqual(newWord.memorizationState, newAttribute.memorizationState)
        XCTAssertEqual(unmemorizedWordListRepository.unmemorizedWordList.count, 0)
    }
    
    func test_updateWordToMemorizingStateSuccess() throws {
        // Given
        let uuid = UUID()
        let originWord = try Word(uuid: uuid, word: "OriginWord", memorizationState: .memorized)
        fakeWordRepository.save(originWord)
        
        // When
        let newAttribute = WordAttribute(word: "NewWord", memorizationState: .memorizing)
        try sut.updateWord(with: newAttribute, id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)!
        XCTAssertEqual(newWord.word, newAttribute.word)
        XCTAssertEqual(newWord.memorizationState, newAttribute.memorizationState)
        XCTAssertEqual(unmemorizedWordListRepository.unmemorizedWordList.count, 1)
    }
    
    func test_updateWordSuccess_whenDuplicateWord() throws {
        // Given
        let uuid = UUID()
        let originWord = try Word(uuid: uuid, word: "OriginWord", memorizationState: .memorizing)
        fakeWordRepository.save(originWord)
        
        // When
        let newAttribute = WordAttribute(word: "OriginWord", memorizationState: .memorized)
        try sut.updateWord(with: newAttribute, id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)!
        XCTAssertEqual(newWord.word, newAttribute.word)
        XCTAssertEqual(newWord.memorizationState, newAttribute.memorizationState)
    }
    
    func test_updateWordFailure_whenInvalidWord() throws {
        // Given
        let uuid = UUID()
        let originWord = try Word(uuid: uuid, word: "OriginWord", memorizationState: .memorizing)
        fakeWordRepository.save(originWord)
        
        // When
        let newAttribute = WordAttribute(word: "", memorizationState: .memorized)
        XCTAssertThrowsError(try sut.updateWord(with: newAttribute, id: uuid))
        
        // Then
        XCTAssertEqual(sut.fetchWord(by: uuid), originWord)
    }
    
    func test_updateWordOnly() throws {
        // Given
        let uuid = UUID()
        let word = try Word(uuid: uuid, word: "Word", memorizationState: .memorizing)
        fakeWordRepository.save(word)
        unmemorizedWordListRepository.addWord(word)
        
        // When
        try sut.updateWord(with: WordAttribute(word: "UpdatedWord"), id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)
        XCTAssertEqual(newWord?.word, "UpdatedWord")
        XCTAssertEqual(newWord?.memorizationState, .memorizing)
        XCTAssertEqual(unmemorizedWordListRepository.getCurrentWord()?.word, "UpdatedWord")
    }
    
    func test_updateMemorizationStateOnly() throws {
        // Given
        let uuid = UUID()
        let word = try Word(uuid: uuid, word: "Word", memorizationState: .memorizing)
        fakeWordRepository.save(word)
        unmemorizedWordListRepository.addWord(word)
        
        // When
        try sut.updateWord(with: WordAttribute(memorizationState: .memorized), id: uuid)
        
        // Then
        let newWord = sut.fetchWord(by: uuid)
        XCTAssertEqual(newWord?.word, "Word")
        XCTAssertEqual(newWord?.memorizationState, .memorized)
        XCTAssertNil(unmemorizedWordListRepository.getCurrentWord())
    }
    
    func test_markWordsAsMemorized() throws {
        // Given
        let uuid1 = UUID()
        let uuid2 = UUID()
        let uuid3 = UUID()
        let uuid4 = UUID()
        let uuid5 = UUID()
        
        let word1 = try Word(uuid: uuid1, word: "A", memorizationState: .memorizing)
        let word2 = try Word(uuid: uuid2, word: "B", memorizationState: .memorizing)
        let word3 = try Word(uuid: uuid3, word: "C", memorizationState: .memorizing)
        let word4 = try Word(uuid: uuid4, word: "D", memorizationState: .memorizing)
        let word5 = try Word(uuid: uuid5, word: "E", memorizationState: .memorizing)
        
        fakeWordRepository._wordList = [
            word1,
            word2,
            word3,
            word4,
            word5,
        ]
        
        unmemorizedWordListRepository.addWord(word1)
        unmemorizedWordListRepository.addWord(word2)
        unmemorizedWordListRepository.addWord(word3)
        unmemorizedWordListRepository.addWord(word4)
        unmemorizedWordListRepository.addWord(word5)
        
        // When
        try sut.markWordsAsMemorized(by: [
            uuid3,
            uuid4,
            uuid5,
        ])
        
        // Then
        XCTAssertEqual(
            Set(sut.fetchMemorizedWordList().map(\.word)),
            Set([word3, word4, word5].map(\.word))
        )
        XCTAssertEqual(unmemorizedWordListRepository.unmemorizedWordList.count, 2)
    }
}
