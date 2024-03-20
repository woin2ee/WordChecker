//
//  WordRepositoryFake.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

@testable import Domain_Word
import Foundation

public final class WordRepositoryFake: WordRepositoryProtocol {

    public var _wordList: [Word] = []

    public init(sampleData: [Word] = []) {
        _wordList = sampleData
    }

    public func getWord(by uuid: UUID) -> Word? {
        return _wordList.first(where: { $0.uuid == uuid })
    }

    public func getWords(by word: String) -> [Word] {
        return _wordList.filter { $0.word.lowercased() == word.lowercased() }
    }

    public func save(_ word: Word) {
        if let index = _wordList.firstIndex(where: { $0.uuid == word.uuid }) {
            _wordList[index] = word
        } else {
            _wordList.append(word)
        }
    }

    public func getAllWords() -> [Word] {
        return _wordList
    }

    public func deleteWord(by uuid: UUID) {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList.remove(at: index)
        }
    }

    public func getUnmemorizedList() -> [Word] {
        return _wordList.filter { $0.memorizedState == .memorizing }
    }

    public func getMemorizedList() -> [Word] {
        return _wordList.filter { $0.memorizedState == .memorized }
    }

    public func reset(to wordList: [Word]) {
        _wordList = wordList
    }

}
