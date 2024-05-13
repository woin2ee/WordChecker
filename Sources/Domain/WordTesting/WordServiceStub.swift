//
//  WordServiceStub.swift
//  Domain_WordTesting
//
//  Created by Jaewon Yun on 3/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_Word
import Foundation

public final class WordServiceStub: WordService {

    var unmemorizedWordList: [Word] = [
        try! .init(word: "Apple"),
        try! .init(word: "Banana"),
        try! .init(word: "Canada"),
        try! .init(word: "Dog"),
    ]

    var memorizedWordList: [Word] = [
        try! .init(word: "Egg", memorizationState: .memorized),
        try! .init(word: "Fail", memorizationState: .memorized),
        try! .init(word: "Grand", memorizationState: .memorized),
        try! .init(word: "House", memorizationState: .memorized),
    ]

    public init(isEmptyStub: Bool = false) {
        if isEmptyStub {
            unmemorizedWordList = []
            memorizedWordList = []
        }
    }

    public func addNewWord(_ word: String) throws {
    }

    public func deleteWord(by uuid: UUID) throws {
    }

    public func fetchWordList() -> [Domain_Word.Word] {
        return unmemorizedWordList + memorizedWordList
    }

    public func fetchUnmemorizedWordList() -> [Domain_Word.Word] {
        return unmemorizedWordList
    }

    public func fetchMemorizedWordList() -> [Domain_Word.Word] {
        return memorizedWordList
    }

    public func fetchWord(by uuid: UUID) -> Domain_Word.Word? {
        return try? .init(word: "Phone")
    }

    public func updateWord(with newAttribute: Domain_Word.WordAttribute, id: UUID) throws {
    }

    public func shuffleUnmemorizedWordList() {
    }

    public func updateToNextWord() {
    }

    public func updateToPreviousWord() {
    }

    public func markCurrentWordAsMemorized() throws {
    }
    
    public func markWordsAsMemorized(by uuids: [UUID]) throws {
    }

    public func getCurrentUnmemorizedWord() -> Domain_Word.Word? {
        return try? .init(word: "Current")
    }

    public func isWordDuplicated(_ word: String) throws -> Bool {
        return true
    }

    public func reset(to newWordList: [Domain_Word.Word]) throws {
    }
}
